#if TESTING_ENABLED

import Foundation

struct ResultViewModel {
  struct Suite: Identifiable {
    var id = UUID()

    struct Method: Identifiable {
      var id = UUID()
      
      let name: String
      let result: TestResult
    }

    let name: String
    let successes: Int
    let failures: Int

    let methods: [Method]
  }

  let suites: [Suite]
}

#endif
