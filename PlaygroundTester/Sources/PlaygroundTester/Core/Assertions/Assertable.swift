#if TESTING_ENABLED

import Foundation
import Difference

extension StaticString {
  var lastPathComponent: String {
    description.components(separatedBy: "/").last ?? "File name missing"
  }
}

protocol CustomAssertionConvertible {
  var assertion: Assertion { get }
}

enum AssertionError: Error, CustomAssertionConvertible {
  case unwrappingNil(assertion: Assertion)

  var assertion: Assertion {
    switch self {
    case let .unwrappingNil(assertion): return assertion
    }
  }
}

public func AssertUnwrap<T>(_ value: T?, message: String = "", file: StaticString = #file, line: UInt = #line) throws -> T {
  guard let value = value else {
    throw AssertionError.unwrappingNil(assertion: .init(
      basicMessage: "Unexpectedly found `nil` when unwrapping an optional value.",
      userMessage: message,
      fullDiff: "Received: nil\nExpected: != nil",
      info: .init(file: file.lastPathComponent, line: line)))
  }
  return value
}

public func Assert(_ value: Bool, message: String = "", file: StaticString = #file, line: UInt = #line) {
  if !value {
    AssertionStore.shared.record(.init(
      basicMessage: "Unexpected `false` value.",
      userMessage: message,
      fullDiff: diff(true, value).joined(),
      info: .init(file: file.lastPathComponent, line: line)))
  }
}

public func AssertFalse(_ value: Bool, message: String = "", file: StaticString = #file, line: UInt = #line) {
  if value {
    AssertionStore.shared.record(.init(
      basicMessage: "Unexpected `true` value.",
      userMessage: message,
      fullDiff: diff(false, value).joined(),
      info: .init(file: file.lastPathComponent, line: line)))
  }
}

public func AssertEqual<T: Equatable>(_ value: T, other: T, message: String = "", file: StaticString = #file, line: UInt = #line) {
  if value != other {
    AssertionStore.shared.record(.init(
      basicMessage: "Values were not equal.",
      userMessage: message,
      fullDiff: diff(value, other).joined(),
      info: .init(file: file.lastPathComponent, line: line)))
  }
}

public func AssertNotEqual<T: Equatable>(_ value: T, other: T, message: String = "", file: StaticString = #file, line: UInt = #line) {
  if value == other {
    AssertionStore.shared.record(.init(
      basicMessage: "Values were equal.",
      userMessage: message,
      fullDiff: diff(value, other).joined(),
      info: .init(file: file.lastPathComponent, line: line)))
  }
}

extension Optional {
  var isNil: Bool {
    switch self {
    case .none: return true
    case .some: return false
    }
  }
}

public func AssertNil<T>(_ value: T?, message: String = "", file: StaticString = #file, line: UInt = #line) {
  if !value.isNil {
    AssertionStore.shared.record(.init(
      basicMessage: "Value was not nil.",
      userMessage: message,
      fullDiff: diff(nil, value).joined(),
      info: .init(file: file.lastPathComponent, line: line)))
  }
}

public func AssertNotNil<T>(_ value: T?, message: String = "", file: StaticString = #file, line: UInt = #line) {
  if value.isNil {
    AssertionStore.shared.record(.init(
      basicMessage: "Value was nil.",
      userMessage: message,
      fullDiff: "Received: nil\nExpected: != nil",
      info: .init(file: file.lastPathComponent, line: line)))
  }
}

public func AssertExpectations(_ expectations: [Expectation], timeout: TimeInterval) {
  let dispatchGroup = DispatchGroup()

  let finishTime = Date().addingTimeInterval(timeout)

  dispatchGroup.enter()
  DispatchQueue.global(qos: .default).async {
    repeat {
      if Date() >= finishTime {
        break
      }
    } while !expectations.allSatisfy(\.isFulfilled)

    for expectation in expectations {
      if let assertion = expectation.assertion {
        AssertionStore.shared.record(assertion)
      }
    }

    dispatchGroup.leave()
  }

  dispatchGroup.wait()
}

#endif
