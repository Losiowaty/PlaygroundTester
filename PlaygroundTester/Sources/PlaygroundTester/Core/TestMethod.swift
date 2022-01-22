#if TESTING_ENABLED

import Foundation

// Represents a single test method.
final class TestMethod {
  private static let errorThrowingSuffix = "AndReturnError:"

  private enum TestError: Error, CustomAssertionConvertible {
    case didNotRun

    var assertion: Assertion {
      switch self {
      case .didNotRun:
        return .init(
          basicMessage: "Test did not run.",
          userMessage: "",
          fullDiff: "",
          info: nil)
      }
    }
  }

  private enum Marker: Error {
    case marker
  }

  private let selector: Selector
  let name: String
  var result: TestResult
  private let isThrowing: Bool

  var isFailed: Bool { !self.result.isSuccess }
  var isSuccess: Bool { !isFailed }

  init(_ selector: Selector) {
    self.selector = selector
    let name = String(cString: sel_getName(selector))

    if name.hasSuffix(Self.errorThrowingSuffix) {
      self.name = String(name.dropLast(Self.errorThrowingSuffix.count))
      self.isThrowing = true
    } else {
      self.name = name
      self.isThrowing = false
    }

    self.result = TestResult(testAssertions: [TestError.didNotRun.asAssertion(testName: self.name)])
  }

  func execute(on testObject: NSObject) throws {
    var error: NSError = (Marker.marker as NSError)

    if self.isThrowing {
      var unmanagedError = Unmanaged.passUnretained(error)

      withUnsafeMutablePointer(to: &unmanagedError) { unsafeMutablePointer in
        let imp: IMP! = testObject.method(for: self.selector)
        let methodAsClosure = unsafeBitCast(
          imp,
          to: (@convention(c)(Any?, Selector, UnsafeMutablePointer<Unmanaged<NSError>>) -> Void).self)
        methodAsClosure(testObject, self.selector, unsafeMutablePointer)

        let result = unsafeMutablePointer.pointee

        error = result.takeUnretainedValue()
      }
    } else {
      testObject.perform(self.selector)
    }

    if (error as? Marker) == nil {
      throw error
    }
  }
}

extension TestMethod: Hashable {
  static func == (lhs: TestMethod, rhs: TestMethod) -> Bool {
    return lhs.selector == rhs.selector
  }

  func hash(into hasher: inout Hasher) {
    self.selector.hash(into: &hasher)
  }
}

#endif
