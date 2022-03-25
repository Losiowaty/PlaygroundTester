#if TESTING_ENABLED

import SwiftUI
import Difference

struct AssertionView: View {

  let assertion: Assertion

  @State var showingFullDiff = false

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(assertion.message).lineLimit(nil)
        Spacer()
        Image(systemName: "chevron.down")
          .rotationEffect(Angle.degrees(self.showingFullDiff ? 180.0 : 0.0))
      }

      if self.showingFullDiff {
        ScrollView([.horizontal]) {
          Text(assertion.fullDiff)
            .font(.callout.monospaced())
        }
      }
    }
    .padding(.init(
      top: 10,
      leading: 5,
      bottom: self.showingFullDiff ? 0 : 10,
      trailing: 5))
    .background(.background)
    .onTapGesture {
      withAnimation {
        self.showingFullDiff.toggle()
      }
    }
  }
}

struct AssertionView_Previews: PreviewProvider {
    static var previews: some View {
      AssertionView(assertion: .init(
        basicMessage: "This assertion has failed",
        userMessage: "User message goes here",
        fullDiff: diff(1, 2).joined(),
        info: nil)
      )
    }
}

#endif
