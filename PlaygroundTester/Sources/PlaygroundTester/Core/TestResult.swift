#if TESTING_ENABLED

import Foundation

final class TestResult: CustomStringConvertible, Equatable {
  let setUpAssertions: [Assertion]
  let testAssertions: [Assertion]
  let tearDownAssertions: [Assertion]

  var isSuccess: Bool { setUpAssertions.isEmpty && testAssertions.isEmpty && tearDownAssertions.isEmpty }
  var failureCount: Int { setUpAssertions.count + testAssertions.count + tearDownAssertions.count }

  var description: String {
    if self.isSuccess {
      return "Success"
    } else {
      return "Failure: \(self.failureCount) assertions failed. "
    }
  }

  init(setUpAssertions: [Assertion] = [], testAssertions: [Assertion] = [], tearDownAssertions: [Assertion] = []) {
    self.setUpAssertions = setUpAssertions
    self.testAssertions = testAssertions
    self.tearDownAssertions = tearDownAssertions
  }

  static func == (lhs: TestResult, rhs: TestResult) -> Bool {
    return lhs.setUpAssertions == rhs.setUpAssertions &&
    lhs.testAssertions == rhs.testAssertions &&
    lhs.tearDownAssertions == rhs.tearDownAssertions
  }
}

#endif
