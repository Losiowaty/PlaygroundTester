#if TESTING_ENABLED

import Foundation

// This class needs to be subclassed to provide test methods.
// Subclasses need to either be marked with `@objcMemebers` or each test method needs to be marked as `@objc`.
open class TestCase: NSObject {
  open class func setUp() {

  }

  open func setUp() throws {

  }

  open func tearDown() throws {
    
  }

  open class func tearDown() {

  }
}

#endif
