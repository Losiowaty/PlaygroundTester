import SwiftUI

struct ResultsToggleButton: View {
  @Binding private(set) var isToggled: Bool
  
  var body: some View {
    Button(action: {
      isToggled.toggle()
    }) {
      let imageName = isToggled ? "xmark.octagon.fill" : "xmark.octagon"
      let tintColor = isToggled ? Color.red : Color.gray
      Image(systemName: imageName)
        .tint(tintColor)
    }
  }
}
