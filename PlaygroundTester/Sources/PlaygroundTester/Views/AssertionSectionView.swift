#if TESTING_ENABLED

import SwiftUI

struct AssertionSectionView: View {

  let assertions: [Assertion]
  let sectionName: String

  var body: some View {
    Section {
      ForEach(assertions) { assertion in
        AssertionView(assertion: assertion).cornerRadius(5)
      }
      .padding([.leading, .trailing], 5)
    } header: {
      HStack {
        Text(sectionName.uppercased())
          .font(.caption)
          .foregroundColor(.secondary)
        Spacer()
      }
      .padding(.init(top: 5, leading: 5, bottom: -5, trailing: 5))
    }
  }
}

#endif
