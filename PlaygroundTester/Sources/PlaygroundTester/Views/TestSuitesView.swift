#if TESTING_ENABLED

import SwiftUI

struct TestSuitesView: View {

  let suites: [ResultViewModel.Suite]
  let title: String

  var body: some View {
    NavigationView {
      List(self.suites) { suite in
        NavigationLink {
          TestMethodsView(methods: suite.methods, title: suite.name)
        } label: {
          TestSuiteView(name: suite.name, failedTests: suite.failures, passedTests: suite.successes)
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle(title)
    }
  }
}

#endif
