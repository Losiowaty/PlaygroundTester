#if TESTING_ENABLED

import Foundation

struct IdentityProvider: Hashable {

  let identityValue: String

  init() {
    // This is needed for package tests, so that in testing we have a stable identifier for equatable convenience.
    if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
      self.identityValue = "static_id_for_tests"
    } else {
      self.identityValue = UUID().uuidString
    }
  }
}

#endif
