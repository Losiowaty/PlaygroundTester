#if TESTING_ENABLED

import SwiftUI

public struct TestMethodView: View {

  let name: String
  let result: TestResult

  public var body: some View {
    VStack {
      HStack(spacing: 10) {
        Text(name)
        Spacer()
        switch result.isSuccess {
        case true:
          Image(systemName: "checkmark.circle.fill")
            .foregroundColor(.green)

        case false:
          Image(systemName: "xmark.octagon.fill")
            .foregroundColor(.red)
        }
      }
    }
  }
}

#endif
