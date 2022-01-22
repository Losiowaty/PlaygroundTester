import XCTest
@testable import PlaygroundTester

@objcMembers
final class TestSuiteSampleTestsClass: TestCase {
  enum ExecutionType: Equatable {
    case classSetUp
    case setUp
    case testMethod
    case tearDown
    case classTearDown
  }

  static var executionOrder: [ExecutionType] = []

  override static func setUp() {
    Self.executionOrder.append(.classSetUp)
  }

  override func setUp() throws {
    Self.executionOrder.append(.setUp)
  }

  override func tearDown() throws {
    Self.executionOrder.append(.tearDown)
  }

  override static func tearDown() {
    Self.executionOrder.append(.classTearDown)
  }

  func testSample() {
    Self.executionOrder.append(.testMethod)
  }

  func testSample2() {
    Self.executionOrder.append(.testMethod)
  }

  func sampleNonTestMethod() {
    XCTFail("Should not call this method.")
  }

  static func cleanupStaticMock() {
    Self.executionOrder = []
  }
}

@objcMembers
final class TestSuiteSampleTestsThrowingClass: TestCase {

  static var setUpErrorToThrow: Error?
  override func setUp() throws {
    if let error = Self.setUpErrorToThrow {
      throw error
    }
  }

  static var tearDownCalled = false
  static var tearDownErrorToThrow: Error?
  override func tearDown() throws {
    Self.tearDownCalled = true
    if let error = Self.tearDownErrorToThrow {
      throw error
    }
  }

  static var testMethodCalled = false
  static var testMethodErrorToThrow: Error?
  func testThrowingMethod() throws {
    Self.testMethodCalled = true
    if let error = Self.testMethodErrorToThrow {
      throw error
    }
  }

  static func cleanupStaticMock() {
    Self.setUpErrorToThrow = nil
    Self.testMethodErrorToThrow = nil
    Self.tearDownErrorToThrow = nil

    Self.testMethodCalled = false
    Self.tearDownCalled = false
  }
}

final class TestSuiteTests: XCTestCase {

  enum TestSuiteTestsError: Error {
    case sampleError
  }

  var mockAssertionStore: MockAssertionStore!

  override func setUp() {
    super.setUp()

    self.mockAssertionStore = .init()
  }

  override func tearDown() {
    TestSuiteSampleTestsClass.cleanupStaticMock()
    TestSuiteSampleTestsThrowingClass.cleanupStaticMock()

    super.tearDown()
  }

  func testNameShouldNotIncludeModuleName() {
    // Act && Assert
    XCTAssertEqual(
      TestSuite(for: TestSuiteSampleTestsClass.self, assertionStore: self.mockAssertionStore).name,
      "TestSuiteSampleTestsClass")
  }

  func testShouldExecuteAllTestRelatedMethodsFromClassInProperOrder() {
    // Act
    TestSuite(for: TestSuiteSampleTestsClass.self, assertionStore: self.mockAssertionStore)
      .executeTests(onTestFinish: { _ in } )

    // Assert
    XCTAssertEqual(
      TestSuiteSampleTestsClass.executionOrder,
      [
        .classSetUp,
        .setUp,
        .testMethod,
        .tearDown,
        .setUp,
        .testMethod,
        .tearDown,
        .classTearDown
      ])
  }

  func testShouldCallPassedClosureAfterEachTestOnMainThread() {
    // Arrange
    let expect = expectation(description: "closure called")
    expect.expectedFulfillmentCount = 2

    // Act
    TestSuite(for: TestSuiteSampleTestsClass.self, assertionStore: self.mockAssertionStore)
      .executeTests(onTestFinish: { _ in
        expect.fulfill()
        XCTAssert(Thread.isMainThread)
      })

    // Assert
    waitForExpectations(timeout: 1, handler: nil)
  }

  func testShouldNotExecuteTestMethodIfSetupThrewAnError() {
    // Arrange
    TestSuiteSampleTestsThrowingClass.setUpErrorToThrow = TestSuiteTestsError.sampleError

    // Act
    TestSuite(for: TestSuiteSampleTestsThrowingClass.self, assertionStore: self.mockAssertionStore)
      .executeTests(onTestFinish: { _ in })

    // Assert
    XCTAssertFalse(TestSuiteSampleTestsThrowingClass.testMethodCalled)
  }

  func testShouldExecuteTeardownIfSetupThrewAnError() {
    // Arrange
    TestSuiteSampleTestsThrowingClass.setUpErrorToThrow = TestSuiteTestsError.sampleError

    // Act
    TestSuite(for: TestSuiteSampleTestsThrowingClass.self, assertionStore: self.mockAssertionStore)
      .executeTests(onTestFinish: { _ in })

    // Assert
    XCTAssert(TestSuiteSampleTestsThrowingClass.tearDownCalled)
  }

  func testShouldPropagateSetupErrorToAssertionStore() {
    // Arrange
    TestSuiteSampleTestsThrowingClass.setUpErrorToThrow = TestSuiteTestsError.sampleError

    // Act
    TestSuite(for: TestSuiteSampleTestsThrowingClass.self, assertionStore: self.mockAssertionStore)
      .executeTests(onTestFinish: { _ in })

    // Assert
    XCTAssertEqual(
      self.mockAssertionStore.recordedAssertions,
      [TestSuiteTestsError.sampleError.asAssertion(testName: "TestSuiteSampleTestsThrowingClass.setUp")])
  }

  func testShouldPropagateTestErrorToAssertionStore() {
    // Arrange
    TestSuiteSampleTestsThrowingClass.testMethodErrorToThrow = TestSuiteTestsError.sampleError

    // Act
    TestSuite(for: TestSuiteSampleTestsThrowingClass.self, assertionStore: self.mockAssertionStore)
      .executeTests(onTestFinish: { _ in })

    // Assert
    XCTAssertEqual(
      self.mockAssertionStore.recordedAssertions,
      [TestSuiteTestsError.sampleError.asAssertion(testName: "testThrowingMethod")])
  }

  func testShouldPropagateTeardownErrorToAssertionStore() {
    // Arrange
    TestSuiteSampleTestsThrowingClass.setUpErrorToThrow = TestSuiteTestsError.sampleError

    // Act
    TestSuite(for: TestSuiteSampleTestsThrowingClass.self, assertionStore: self.mockAssertionStore)
      .executeTests(onTestFinish: { _ in })

    // Assert
    XCTAssertEqual(
      self.mockAssertionStore.recordedAssertions,
      [TestSuiteTestsError.sampleError.asAssertion(testName: "TestSuiteSampleTestsThrowingClass.setUp")])
  }

  func testShouldPassTestMethodResultFromAssertionStoreToClosure() {
    // Arrange
    let sampleTestResult = TestResult(
      setUpAssertions: [
        TestSuiteTestsError.sampleError.asAssertion(testName: "setup1"),
        TestSuiteTestsError.sampleError.asAssertion(testName: "setup2")
      ],
      testAssertions: [
        TestSuiteTestsError.sampleError.asAssertion(testName: "test1"),
        TestSuiteTestsError.sampleError.asAssertion(testName: "test2"),
        TestSuiteTestsError.sampleError.asAssertion(testName: "test3"),
      ],
      tearDownAssertions: [
        TestSuiteTestsError.sampleError.asAssertion(testName: "teardown")
      ])

    self.mockAssertionStore.mockGetTestResult = { return sampleTestResult }

    let expect = expectation(description: "closure is called on main")

    // Act
    var capturedTestResult: TestResult?
    TestSuite(for: TestSuiteSampleTestsThrowingClass.self, assertionStore: self.mockAssertionStore)
      .executeTests(onTestFinish: { result in
        expect.fulfill()
        capturedTestResult = result
      })

    // Assert
    waitForExpectations(timeout: 1, handler: nil)
    XCTAssertEqual(capturedTestResult, sampleTestResult)
  }
}
