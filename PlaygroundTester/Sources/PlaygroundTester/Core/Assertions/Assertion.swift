#if TESTING_ENABLED

import Foundation

extension Error {
  func asAssertion(testName: String) -> Assertion {
    (self as? CustomAssertionConvertible)?.assertion ?? 
    .init(
      basicMessage: "\(testName) threw an error.",
      userMessage: "",
      fullDiff: "\(self)\n",
      info: nil)
  }
}

struct Assertion: Equatable, Identifiable {

  var id: IdentityProvider = IdentityProvider()

  struct Info: Equatable {
    let file: String
    let line: UInt
  }

  let basicMessage: String
  let userMessage: String
  let fullDiff: String
  let info: Info?

  var message: String {
    if self.userMessage.isEmpty {
      return self.basicMessage
    }

    return self.basicMessage + " - " + self.userMessage
  }
}

#endif
