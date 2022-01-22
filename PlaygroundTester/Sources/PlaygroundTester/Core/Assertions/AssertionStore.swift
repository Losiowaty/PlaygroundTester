#if TESTING_ENABLED

import Foundation

protocol AssertionStoreProtocol {
  var currentMode: AssertionStore.Mode { get set }

  func record(_ result: Assertion)
  func clearStore()
  func getTestResult() -> TestResult
}

final class AssertionStore: AssertionStoreProtocol {
  enum Mode {
    case setUp
    case test
    case tearDown
  }

  static var shared: AssertionStore = .init()

  private var setupAssertions: [Assertion] = []
  private var currentAssertions: [Assertion] = []
  private var tearDownAssertions: [Assertion] = []

  var currentMode: Mode = .setUp

  private init() {}

  func record(_ result: Assertion) {
    switch self.currentMode {
    case .setUp: setupAssertions.append(result)
    case .test: currentAssertions.append(result)
    case .tearDown: tearDownAssertions.append(result)
    }
  }

  func clearStore() {
    self.currentMode = .setUp

    setupAssertions = []
    currentAssertions = []
    tearDownAssertions = []
  }

  func getTestResult() -> TestResult {
    defer {
      self.clearStore()
    }

    return TestResult(
      setUpAssertions: self.setupAssertions,
      testAssertions: self.currentAssertions,
      tearDownAssertions: self.tearDownAssertions)
  }
}

#endif
