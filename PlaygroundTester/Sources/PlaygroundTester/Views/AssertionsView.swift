#if TESTING_ENABLED

import SwiftUI

struct AssertionsView: View {

  let testResult: TestResult
  let title: String

  var body: some View {
    ScrollView {
      if testResult.setUpAssertions.count > 0 {
        AssertionSectionView(assertions: testResult.setUpAssertions, sectionName: "setup assertion")
      }

      if testResult.testAssertions.count > 0 {
        AssertionSectionView(assertions: testResult.testAssertions, sectionName: "test assertions")
      }

      if testResult.tearDownAssertions.count > 0 {
        AssertionSectionView(assertions: testResult.tearDownAssertions, sectionName: "teardown assertions")
      }
      Color.clear.padding(.bottom, 50)
    }
    .background(content: { Color(UIColor.tertiarySystemGroupedBackground) })
    .navigationTitle(title)
  }
}

#endif
