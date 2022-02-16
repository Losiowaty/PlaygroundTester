#if TESTING_ENABLED

import SwiftUI

struct TestMethodsView: View {

  let methods: [ResultViewModel.Suite.Method]
  let title: String

  @Binding private(set) var failuresOnly: Bool

  var body: some View {
    let results = failuresOnly ? methods.filter { $0.result.isSuccess == false } : methods
    List(results) { method in
      if method.result.isSuccess {
        TestMethodView(name: method.name, result: method.result)
      } else {
        NavigationLink {
          AssertionsView(testResult: method.result, title: method.name)
        } label: {
          TestMethodView(name: method.name, result: method.result)
        }
      }
    }.navigationTitle(title)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        if results.isEmpty == false {
          ResultsToggleButton(isToggled: $failuresOnly)
        }
      }
    }
  }
}

#endif
