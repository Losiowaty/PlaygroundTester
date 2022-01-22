#if TESTING_ENABLED

import SwiftUI

public struct TestSuiteView: View {

  let name: String
  let failedTests: Int
  let passedTests: Int

  public var body: some View {
    VStack {
      HStack(spacing: 10) {
        Text(name)
        Spacer()
        if failedTests > 0 {
          Image(systemName: "xmark.octagon.fill")
            .foregroundColor(.red)
          Text("\(failedTests)")
        }
        if passedTests > 0 {
          Image(systemName: "checkmark.circle.fill")
            .foregroundColor(.green)
          Text("\(passedTests)")
        }
      }
    }
  }
}

#endif

