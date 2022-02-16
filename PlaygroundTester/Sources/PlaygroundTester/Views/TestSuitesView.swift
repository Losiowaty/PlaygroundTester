#if TESTING_ENABLED

import SwiftUI

struct TestSuitesView: View {

  let suites: [ResultViewModel.Suite]
  let title: String

  @State private(set) var failuresOnly = false
  
  var body: some View {
    NavigationView {
      let results = failuresOnly ? suites.filter { $0.failures > 0 } : suites
      List(results) { suite in
        NavigationLink {
          TestMethodsView(methods: suite.methods, title: suite.name, failuresOnly: $failuresOnly)
        } label: {
          TestSuiteView(name: suite.name, failedTests: suite.failures, passedTests: suite.successes)
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle(title)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          if results.isEmpty == false {
            ResultsToggleButton(isToggled: $failuresOnly)
          }
        }
      }
    }
  }
}

#endif
