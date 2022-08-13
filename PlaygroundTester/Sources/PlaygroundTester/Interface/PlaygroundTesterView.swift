#if TESTING_ENABLED

import SwiftUI

public struct PlaygroundTesterView<Content: View>: View {
  let content: Content

  public init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  public var body: some View {
    if PlaygroundTesterConfigurator.isTesting {
      TestingView()
    } else {
      content
    }
  }
}

#endif

public enum PlaygroundTesterConfigurator {
  public static var isTesting = false
}
