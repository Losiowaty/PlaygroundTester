#if TESTING_ENABLED

import SwiftUI

struct TestingView: View {

  @StateObject var viewModel = TestViewViewModel()

  @State var showingResults = false

  public var body: some View {
    Group {
      if self.showingResults {
        TestSuitesView(suites: self.viewModel.results.suites, title: "Results")
      } else {
        self.testingView
      }
    }
  }

  private var testingView: some View {
    VStack {
      switch viewModel.state {
      case .searchingForTests:
        Text("Looking for tests...")
        ProgressView().progressViewStyle(.circular)

      case let .executing(finished, success, failure):
        Text("Found \(self.viewModel.totalClasses) test classes and \(self.viewModel.totalTests) methods.")
        Text("Executing....")
        ProgressView().progressViewStyle(.circular)
        Text("\(finished) / \(self.viewModel.totalTests)")
        HStack {
          if failure > 0 {
            Image(systemName: "xmark.octagon.fill")
              .foregroundColor(.red)
            Text("\(failure)")
          }
          if success > 0 {
            Image(systemName: "checkmark.circle.fill")
              .foregroundColor(.green)
            Text("\(success)")
          }
        }

      case .done:
        Text("Done!").onAppear {
          self.showingResults = true
        }
      }
    }
    .onAppear {
      self.viewModel.start()
    }
  }
}

#endif
