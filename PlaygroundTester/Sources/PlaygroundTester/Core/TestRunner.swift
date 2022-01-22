#if TESTING_ENABLED

import Foundation

// Main class responsible for finding and executing tests
final class TestRunner: TestRunnerProtocol {
  private(set) var suites: [TestSuite] = []

  var totalSuites: Int { self.suites.count }
  var totalMethods: Int { self.suites.reduce(into: 0) { $0 += $1.methods.count } }

  func findTests(completion: @escaping () -> Void) {
    
    DispatchQueue.global(qos: .userInitiated).async {
      let expectedClassCount = objc_getClassList(nil, 0)
      let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(expectedClassCount))

      let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(allClasses)
      let actualClassCount: Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)

      var classes = [TestSuite]()
      for i in 0 ..< actualClassCount {
        if let currentClass: AnyClass = allClasses[Int(i)],
           class_getSuperclass(currentClass) == TestCase.self {

          classes.append(.init(for: currentClass))
        }
      }

      allClasses.deallocate()

      self.suites = classes

      DispatchQueue.main.async {
        completion()
      }
    }
  }

  func executeAllTests(onTestFinish: @escaping (TestResult) -> Void, completion: @escaping () -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
      for suite in self.suites {
        suite.executeTests(onTestFinish: onTestFinish)
      }
      DispatchQueue.main.async {
        completion()
      }
    }
  }

  func gatherResults() -> ResultViewModel {
    return .init(suites: self.suites.map {
      .init(
        name: $0.name,
        successes: $0.methods.filter(\.isSuccess).count,
        failures: $0.methods.filter(\.isFailed).count,
        methods: $0.methods.map { .init(name: $0.name, result: $0.result) }.sorted(by: { m1, _ in
          !m1.result.isSuccess
        }))
    }.sorted(by: {
      $0.failures > $1.failures
    })
    )
  }
}

#endif
