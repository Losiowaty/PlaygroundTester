#if TESTING_ENABLED

import SwiftUI

struct TestMethodsView: View {

  let methods: [ResultViewModel.Suite.Method]
  let title: String

  var body: some View {
    List(methods) { method in
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
  }
}

#endif
