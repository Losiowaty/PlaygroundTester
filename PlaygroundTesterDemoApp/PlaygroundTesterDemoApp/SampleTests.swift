//
//  File.swift
//  
//
//  Created by Pawel Lopusinski on 6/2/22.
//

import Foundation
import PlaygroundTester

enum SampleError: Error {
  case testMethodError
  case setUpError
  case tearDownError
}

struct SecondStruct: Equatable {
  let nameThatHasLongName: String
}

struct Struct: Equatable {
  let name: String
  let second: SecondStruct
}

@objcMembers
class Tests: TestCase {

  func testEmpty() {
  }

  func testSingleSuccess() {
    Assert(true)
  }

  func testSingleFailure() {
    Assert(false)
  }

  func testMultipleSuccess() {
    Assert(true)
    Assert(true)
    Assert(true)
    Assert(true)
  }

  func testMultipleFailures() {
    Assert(false)
    Assert(false)
    Assert(false)
    Assert(false)
  }

  func testFailureWithComplexObject() {
    let object1 = Struct(name: "shortName", second: .init(nameThatHasLongName: "secondLongerName"))
    let object2 = Struct(name: "shortName_2", second: .init(nameThatHasLongName: "secondLongerName_2"))

    AssertEqual(object1, other: object2)
  }

  func testFailureWithUserMessage() {
    Assert(false, message: "User message says it should never be false.")
  }
}

@objcMembers
final class ThrowingTests: TestCase {
  func testThrowingJustThrows() throws {
    throw SampleError.testMethodError
  }

  func testThrowingSuccessThenThrow() throws {
    Assert(true)
    throw SampleError.testMethodError
  }

  func testThrowingFailureThenThrow() throws {
    Assert(false)
    throw SampleError.testMethodError
  }

  func testThrowingNoThrowAndSuccess() throws {
    Assert(true)
  }

  func testThrowingNoThrowAndFailure() throws {
    Assert(false)
  }

  func testThrowingAssertUnwrap() throws {
    let optional: Int? = nil

    _ = try AssertUnwrap(optional)
  }
}

@objcMembers
final class ExpectationTests: TestCase {
  func testExpectationFailed() {
    let expect = Expectation(name: "exp1")

    AssertExpectations([expect], timeout: 0.1)
  }

  func testOverfulfilledExpectation() {
    let expect = Expectation(name: "exp1")
    expect.expectedFulfilmentCount = 3

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      Assert(Thread.isMainThread)
      expect.fulfill()
      expect.fulfill()
      expect.fulfill()
      expect.fulfill()
      expect.fulfill()
    }

    AssertExpectations([expect], timeout: 10)
  }

  func testInvertedExpectationNotTriggered() {
    let expect = Expectation(name: "exp1")
    expect.inverted = true

    AssertExpectations([expect], timeout: 0.1)
  }

  func testInvertedExpectationTriggered() {
    let expect = Expectation(name: "exp1")
    expect.inverted = true

    expect.fulfill()

    AssertExpectations([expect], timeout: 0.1)
  }

  func testInvertedExpectationWithMultipleHitsUnderThreshold() {
    let expect = Expectation(name: "exp1")
    expect.expectedFulfilmentCount = 10
    expect.inverted = true

    expect.fulfill()

    AssertExpectations([expect], timeout: 0.1)
  }

  func testInvertedExpectationWithMultipleHitsOverThreshold() {
    let expect = Expectation(name: "exp1")
    expect.expectedFulfilmentCount = 2
    expect.inverted = true

    expect.fulfill()
    expect.fulfill()
    expect.fulfill()
    expect.fulfill()

    AssertExpectations([expect], timeout: 0.1)
  }

  func testExpectationSuccess() {
    let expect = Expectation(name: "exp1")

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      Assert(Thread.isMainThread)
      expect.fulfill()
    }

    AssertExpectations([expect], timeout: 10)
  }
}

@objcMembers
final class EmptyTestSuite: TestCase {}

@objcMembers
final class SetupAndTearDownAssertionSuccessTests: TestCase {
  override func setUp() throws {
    try super.setUp()

    Assert(true)
  }

  func testSuccess() {
    Assert(true)
  }

  func testFailure() {
    Assert(false)
  }

  override func tearDown() throws {
    Assert(true)

    try super.tearDown()
  }
}

@objcMembers
final class SetupAndTearDownAssertionFailureTests: TestCase {
  override func setUp() throws {
    try super.setUp()

    Assert(false)
  }

  func testSuccess() {
    Assert(true)
  }

  func testFailure() {
    Assert(false)
  }

  override func tearDown() throws {
    Assert(false)

    try super.tearDown()
  }
}

@objcMembers
final class SetupAndTearDownThrowTests: TestCase {

  override func setUp() throws {
    try super.setUp()

    Assert(false)
    throw SampleError.setUpError
  }

  func testSuccess() {
    Assert(true)
  }

  func testFailure() {
    Assert(false)
  }

  override func tearDown() throws {
    Assert(false)

    try super.tearDown()

    throw SampleError.tearDownError
  }
}
