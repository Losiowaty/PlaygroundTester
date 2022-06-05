//
//  TestResultTests.swift
//  
//
//  Created by Paweł Łopusiński on 05/06/2022.
//

import XCTest
@testable import PlaygroundTester

final class TestResultTests: XCTestCase {
    
    func testIsSuccess_ShouldBeTrue_whenNoAssertionsPassedInInit() {
        // Act && Assert
        XCTAssert(TestResult(
            setUpAssertions: [],
            testAssertions: [],
            tearDownAssertions: []).isSuccess)
    }
    
    func testIsSuccess_ShouldBeFalse_whenSetupAssertionIsPresent() {
        // Act && Assert
        XCTAssertFalse(TestResult(
            setUpAssertions: [
                .init(basicMessage: "", userMessage: "", fullDiff: "", info: nil)
            ],
            testAssertions: [],
            tearDownAssertions: []).isSuccess)
    }
    
    func testIsSuccess_ShouldBeFalse_whenTestAssertionIsPresent() {
        // Act && Assert
        XCTAssertFalse(TestResult(
            setUpAssertions: [],
            testAssertions: [
                .init(basicMessage: "", userMessage: "", fullDiff: "", info: nil)
            ],
            tearDownAssertions: []).isSuccess)
    }
    
    func testIsSuccess_ShouldBeFalse_whenTeardownAssertionIsPresent() {
        // Act && Assert
        XCTAssertFalse(TestResult(
            setUpAssertions: [],
            testAssertions: [],
            tearDownAssertions: [
                .init(basicMessage: "", userMessage: "", fullDiff: "", info: nil)
            ]).isSuccess)
    }

    func testFailureCount_shouldCountAllAssertions() {
        // Act && Assert
        XCTAssertEqual(
            TestResult(
                setUpAssertions: [
                    .init(basicMessage: "", userMessage: "", fullDiff: "", info: nil),
                    .init(basicMessage: "", userMessage: "", fullDiff: "", info: nil)
                ],
                testAssertions: [
                    .init(basicMessage: "", userMessage: "", fullDiff: "", info: nil),
                    .init(basicMessage: "", userMessage: "", fullDiff: "", info: nil),
                    .init(basicMessage: "", userMessage: "", fullDiff: "", info: nil),
                    .init(basicMessage: "", userMessage: "", fullDiff: "", info: nil)
                ],
                tearDownAssertions: [
                    .init(basicMessage: "", userMessage: "", fullDiff: "", info: nil)
                ])
            .failureCount,
            7)
    }
}
