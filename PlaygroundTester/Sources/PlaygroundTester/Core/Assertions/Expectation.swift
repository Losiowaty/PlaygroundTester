#if TESTING_ENABLED

import Foundation
import Difference

final public class Expectation {
  private struct FulfillmentCount<T: Equatable>: Equatable {
    let fulfilmentCount: T

    init(_ count: T) { self.fulfilmentCount = count }
  }

  public var assertOnOverFulfilment: Bool = true
  public var expectedFulfilmentCount: UInt = 1
  public var inverted = false

  private let name: String
  private let info: Assertion.Info

  private var count: UInt = 0

  var isFulfilled: Bool { self.count >= self.expectedFulfilmentCount }

  public init(name: String, file: StaticString = #file, line: UInt = #line) {
    self.name = name
    self.info = .init(file: file.lastPathComponent, line: line)
  }

  public func fulfill() {
    count += 1
  }

  var assertion: Assertion? {
    switch (count, inverted) {
    case (0..<expectedFulfilmentCount, false): // basic expectation not fulfilled expected number of times
      return Assertion(
        basicMessage: "Asynchronous wait failed for expectation : \"\(self.name)\"",
        userMessage: "",
        fullDiff: diff(FulfillmentCount(self.expectedFulfilmentCount), FulfillmentCount(self.count)).joined(),
        info: self.info)

    case (expectedFulfilmentCount, false): // basic expectation fulfilled properly
      return nil

    case ((expectedFulfilmentCount + 1)..., false): // basic expectation overfulfilled
      if self.assertOnOverFulfilment {
        return Assertion(
          basicMessage: "Expectation was overfulfiled : \"\(self.name)\"",
          userMessage: "",
          fullDiff: diff(FulfillmentCount(self.expectedFulfilmentCount), FulfillmentCount(self.count)).joined(),
          info: self.info)
      } else {
        return nil
      }

    case (0..<expectedFulfilmentCount, true): // inverted expectation triggered less than (un)expected number to fail
      return nil

    case (expectedFulfilmentCount..., true): // Inverted expectation was triggered at least (un)expected number to fail
      return Assertion(
        basicMessage: "Inverted expectation was overfulfiled : \"\(self.name)\"",
        userMessage: "",
        fullDiff: diff(FulfillmentCount("< \(self.expectedFulfilmentCount)"), FulfillmentCount("\(count)")).joined(),
        info: self.info)

    case (_, _):
      // Should not happen, all cases are covered above, `count` is UInt so it cannot be < 0
      return nil
    }
  }
}

#endif
