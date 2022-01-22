import XCTest
@testable import PlaygroundTester

final class TestMethodTests: XCTestCase {

  @objcMembers
  final class SampleClass: NSObject {
    var sampleMethodCalledCount = 0

    func sampleMethod() {
      self.sampleMethodCalledCount += 1
    }
  }

  @objcMembers
  final class SampleThrowingClass: NSObject {
    var errorToThrow: Error?
    func sampleThrowingMethod() throws {
      if let errorToThrow = errorToThrow {
        throw errorToThrow
      }
    }
  }

  func testNameForSimpleMethod() throws {
    // Act
    let sampleMethod = TestMethod(#selector(SampleClass.sampleMethod))

    // Assert
    XCTAssertEqual(sampleMethod.name, "sampleMethod")
  }

  func testNameForThrowingMethod() throws {
    // Act
    let method = TestMethod(#selector(SampleThrowingClass.sampleThrowingMethod))

    // Assert
    XCTAssertEqual(method.name, "sampleThrowingMethod")
  }

  func testIsSuccessOrFailure() {
    // Arrange
    let method = TestMethod(#selector(SampleClass.sampleMethod))

    // Act && Assert
    method.result = TestResult()
    XCTAssertFalse(method.isFailed)
    XCTAssert(method.isSuccess)

    method.result = TestResult(testAssertions: [NSError(domain: "", code: 0, userInfo: nil).asAssertion(testName: "")])
    XCTAssert(method.isFailed)
    XCTAssertFalse(method.isSuccess)
  }

  func testInitialTestResult() {
    // Arrange
    let method = TestMethod(#selector(SampleClass.sampleMethod))

    // Assert
    XCTAssert(method.isFailed)
    XCTAssertEqual(method.result.testAssertions.count, 1)
    XCTAssertEqual(method.result.testAssertions.first?.basicMessage, "Test did not run.")
  }

  func testExecuteShouldPerformSelectorOnPassedInstance() {
    // Arrange
    let sampleInstance = SampleClass()
    let otherInstance = SampleClass()

    let method = TestMethod(#selector(SampleClass.sampleMethod))

    // Act
    XCTAssertNoThrow(try method.execute(on: sampleInstance))

    // Assert
    XCTAssertEqual(sampleInstance.sampleMethodCalledCount, 1)
    XCTAssertEqual(otherInstance.sampleMethodCalledCount, 0)
  }

  func testExecuteShouldNotThrowIfThrowingFunctionDidntThrow() {
    // Arrange
    let sampleInstance = SampleThrowingClass()
    sampleInstance.errorToThrow = nil

    let method = TestMethod(#selector(SampleThrowingClass.sampleThrowingMethod))

    // Act && Arrange
    XCTAssertNoThrow(try method.execute(on: sampleInstance))
  }

  func testExecuteShouldRethrowErrorThrownFromMethod() {
    // Arrange
    let sampleError = NSError(domain: "playgroundtester.tests.\(#function)", code: 1, userInfo: nil)
    let sampleInstance = SampleThrowingClass()
    sampleInstance.errorToThrow = sampleError

    let method = TestMethod(#selector(SampleThrowingClass.sampleThrowingMethod))

    var caughtError: Error?
    do {
      // Act
      try method.execute(on: sampleInstance)
    } catch {
      caughtError = error
    }

    // Assert
    XCTAssertEqual((caughtError as NSError?), sampleError)
  }
}
