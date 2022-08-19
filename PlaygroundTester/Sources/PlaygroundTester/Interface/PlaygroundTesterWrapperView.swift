import SwiftUI

public struct PlaygroundTesterWrapperView<Content: View>: View {
  let content: Content
    
  private var isTesting: Bool {
    #if TESTING_ENABLED
      return PlaygroundTesterConfiguration.isTesting
    #else
      return false
    #endif
  }

  public init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  public var body: some View {
    if isTesting {
      #if TESTING_ENABLED
        TestingView()
      #endif
    } else {
      content
    }
  }
}

public enum PlaygroundTesterConfiguration {
  public static var isTesting = false
}
