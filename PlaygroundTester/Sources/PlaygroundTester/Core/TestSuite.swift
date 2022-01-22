#if TESTING_ENABLED

import Foundation

// Represents a single test class
final class TestSuite {

  let name: String

  private let testCase: AnyClass
  private(set) var methods: Set<TestMethod> = []

  private(set) var assertionStore: AssertionStoreProtocol

  init(for testCase: AnyClass, assertionStore: AssertionStoreProtocol = AssertionStore.shared) {
    self.testCase = testCase
    self.assertionStore = assertionStore

    self.name = String(cString: class_getName(testCase))
      .components(separatedBy: ".")
      .dropFirst()
      .joined(separator: ".")

    self.methods = self.testMethods()
  }

  private func testMethods() -> Set<TestMethod> {
    var methodCount: UInt32 = 0
    var methods: Set<TestMethod> = []

    if let methodList = class_copyMethodList(testCase, &methodCount) {
      for i in 0..<Int(methodCount) {
        let selector = method_getName(methodList[i])
        if selector.description.hasPrefix("test") {
          methods.insert(.init(selector))
        }
      }
    }

    return methods
  }

  func executeTests(onTestFinish: @escaping (TestResult) -> Void) {
    if let testObject = class_createInstance(testCase, 0) as? TestCase {
      // Setup before all tests
      type(of: testObject).setUp()

      for testMethod in self.methods {
        self.assertionStore.clearStore()
        
        // Setup
        var setupFailed = false
        self.assertionStore.currentMode = .setUp
        do {
          try testObject.setUp()
        } catch {
          setupFailed = true
          self.assertionStore.record(error.asAssertion(testName: "\(self.name).setUp"))
        }

        // Run test
        if !setupFailed {
          self.assertionStore.currentMode = .test
          do {
            try testMethod.execute(on: testObject)
          } catch {
            self.assertionStore.record(error.asAssertion(testName: testMethod.name))
          }
        }

        // Teardown
        self.assertionStore.currentMode = .tearDown
        do {
          try testObject.tearDown()
        } catch {
          self.assertionStore.record(error.asAssertion(testName: "\(self.name).tearDown"))
        }

        testMethod.result = self.assertionStore.getTestResult()

        DispatchQueue.main.async {
          onTestFinish(testMethod.result)
        }
      }

      // Tear down after all tests
      type(of: testObject).tearDown()
    } else {
      // TODO: add error handling here for case when `testObject` == nil
      print("testObject was nil for test class \(self.name)")
    }
  }
}

#endif
