//
//  File.swift
//  
//
//  Created by Pawel Lopusinski on 14/2/22.
//

@testable import PlaygroundTester

final class MockAssertionStore: AssertionStoreProtocol {
  var currentMode: AssertionStore.Mode = .setUp

  var recordedAssertions: [Assertion] = []
  func record(_ result: Assertion) {
    self.recordedAssertions.append(result)
  }

  var clearStoreCalledCount = 0
  func clearStore() {
    clearStoreCalledCount += 1
  }

  var mockGetTestResult: (() -> TestResult)?
  func getTestResult() -> TestResult {
    self.mockGetTestResult?() ?? TestResult()
  }
}
