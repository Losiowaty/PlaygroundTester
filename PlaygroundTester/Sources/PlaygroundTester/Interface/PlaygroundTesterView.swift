#if TESTING_ENABLED

import SwiftUI

@available(*, deprecated, message: "This view is being deprecated - please switch to `PlaygroundTesterWrapperView` and refer to Readme on new appraoach. This view may be removed in future versions.")
public struct PlaygroundTesterView: View {

  public init() {}

  public var body: some View {
    TestingView()
  }
}

#endif
