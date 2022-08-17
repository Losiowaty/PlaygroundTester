[![Swift](https://github.com/Losiowaty/PlaygroundTester/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/Losiowaty/PlaygroundTester/actions/workflows/swift.yml) &nbsp;&nbsp;&nbsp; [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FLosiowaty%2FPlaygroundTester%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Losiowaty/PlaygroundTester) &nbsp;&nbsp;&nbsp; [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FLosiowaty%2FPlaygroundTester%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Losiowaty/PlaygroundTester) &nbsp;&nbsp;&nbsp; [![License: Unlicense](https://img.shields.io/badge/license-Unlicense-blue.svg)](http://unlicense.org/)

# PlaygroundTester

`PlaygroundTester` is a package that enables you to add tests to your [iPad Swift Playgrounds](https://apps.apple.com/pl/app/swift-playgrounds/id908519492) project.

## Installation

Just add `PlaygroundTester` package to the project as you normally would.

## Usage

### Adding tests
For `PlaygroundTester` to find and properly execute tests your test class needs to :
1. Inherit from `TestCase`
2. Be marked as having `@objcMembers`
    1. Alternatively you can mark each method you want to be discoverable as `@objc`

At this momment inheriting from another test class is **not supported** (so you cannot create a `class BaseTests: TestCase` that you will then inherit other test classes from).

Sample test class declaration :
```swift
@objcMembers
final class MyTests: TestCase {
}
```

#### setUp / tearDown
You can override four methods to help with setting up and cleaning up after your tests.
```swift
  // Called once for the entire test class, before any tests are run.
  open class func setUp() {  }

  // Called before each test method.
  // If this method throws, the test method won't be executed, but `tearDown` will be.
  open func setUp() throws { }

  // Called after each test method.
  open func tearDown() throws { }

  // Called once for the entire test class, after all tests are run.
  open class func tearDown() { }
}
```

#### Adding test methods
For `PlaygroundTester` to discover your test methods and run them automatically they have to :
1. Be non-`private` (so `public` or `internal`)
2. Begin with `test`

Any `private` methods or ones not begininning with `test` will not be automatically executed, so you can use this opportunity to define helper methods.

Sample method definition :
```swift
func testSample() { }

// Methods that won't be run automaticaly
private func testPrivateSample() { }

func helperMethod() { }
```

#### Throwing test methods
Throwing test methods are supported by `PlaygroundTester` - just define your method following the rules above and add `throws` to its definition.
`PlaygroundTester` will catch the thrown error and report it.

Sample throwing test method definition :
```swift
func testSampleThrowing() throws { }
```

### Asserting
Currently there is a basic set of assertion methods available that mimick the asserting style of `XCTest`: 
```swift
// Assert of a passed boolean value is `true`/`false`
public func Assert(_ value: Bool, message: String = "")
public func AssertFalse(_ value: Bool, message: String = "")

// Assert if two passed values are equal / not equal.
public func AssertEqual<T: Equatable>(_ value: T, other: T, message: String = "") 
public func AssertNotEqual<T: Equatable>(_ value: T, other: T, message: String = "")

// assert if passed optional value is `nil` / not `nil`.
public func AssertNil<T>(_ value: T?, message: String = "")
public func AssertNotNil<T>(_ value: T?, message: String = "")
```
There are a few methods missing from achieving parity with `XCTAssert` family of methods which will be added later.

#### Unwrapping
`PlaygroundTester` provides a similar method to `XCTUnwrap`:
```swift
// Return an unwrapped value, or throw an error if `nil` was passed.
public func AssertUnwrap<T>(_ value: T?, message: String = "") throws -> T
```
You should mark your test method with `throws` to avoid the need to handle this thrown error yourself.

Sample method with `AssertUnwrap` :
```swift
func testSampleAssertUnwrap() throws {

  let sampleArray = ["first", "second"]
  
  let firstValue = try XCTUnwrap(sampleArray.first, "Array should have a first element").

  // `firstValue` is non-optional here
}
```

#### Expectations
`PlaygroundTester` supports waiting on expectations to test asynchronous code.
Expectations can be configured with 3 properties : 
1. `expectedFulfilmentCount (default == 1)` - how many times should the expectation be fullfilled to be considered as met. Expectations will fail if they are overfulfilled.
2. `inverted (default == false)` - if the expectation is `inverted` it will fail, if it is fullfilled.
    1. If you have an `inverted` expectation with `expectedFulfilmentCount > 1`  it will be considered as met if it gets fullfilled less than `expectedFulfilmentCount` times.

You use the `AssertExpectations` method to wait on created expectations :
```swift
// Will wait for `timeout` seconds for `expectations` to be fulfilled before continuing test execution.
public func AssertExpectations(_ expectations: [Expectation], timeout: TimeInterval)
```

Sample test with expectation :
```swift
func testSampleExpectation() {
  let expectation = Expectation(name: "Wait for main thread")
  
  DispatchQueue.main.async { 
    expectation.fulfill()
  }
  
  AssertExpectations([expectation], timeout: 2)
}
```
At this moment unwaited expectations don't trigger an assertion failure.

### Runing tests
In order to execute your tests you need to do one final thing : Wrap your view in PlaygroundTesterView and set PlaygroundTester.PlaygroundTesterConfiguration.isTesting flag to true.
In your `App` object just do this : 

```swift
struct Myapp: App {
    init() {
        PlaygroundTester.PlaygroundTesterConfiguration.isTesting = true
    }
    var body: some Scene {
        WindowGroup {
          PlaygroundTester.PlaygroundTesterWrapperView {
            // YourContentView()
          }
        }
    }
}
```
After that when running the app either in fullscreen or in preview mode will instead discover and run your tests.

#### Inspecting results
After the tests are run, you can navigate them to inspect their results and see which assertions failed.

https://user-images.githubusercontent.com/4209155/154171145-2387477e-a665-4991-b63e-3f2dfe3cad73.mp4

## Patching `Package.swift`
Swift Playgrounds doesn't support multiple targets at this time, so your test files will need to be kept alongside regular application code.
The package itself has compilation guards around its code, so that when creating a release build most of it will be omitted from you production app.
What is left is the minimal set of object and function definitions, so that your code compiles just fine, and all calls to `PlaygroundTester` provided
objects/functions resolves to basically no-ops.

If you'd like to also discard your tests from release builds, you'll need to add a compilation flag to your app.

For now you'll need to follow these steps to add a compilation flag to your project :
1. Send the app project to a Mac (for example via AirDrop)
2. Open the package contents (right click -> Show Package Contents)
3. Open `Package.swift` file
4. This file should contain a single `.executableTarget` definition.
5. Add this argument to the target : `swiftSettings: [.define("TESTING_ENABLED", .when(configuration: .debug))]`
6. Save the file and share the app back to your iPad.

In the end the target definition should look similar to this :
```swift
targets: [
        .executableTarget(
            name: "AppModule",
            dependencies: [
              // if any
            ],
            path: ".",
            swiftSettings: [.define("TESTING_ENABLED", .when(configuration: .debug))]
        )
    ]
```
You can of course choose any name for the flag.

NOTE : I hope to automate this process in [Patching Package.swift](https://github.com/Losiowaty/PlaygroundTester/issues/11)

## Supported features
- Automatic test discovery & execution
- UI for inspecting test results
- Basic assertions
- Expectations
- Throwing tests methods
- `setUp`/`tearDown` methods

### Roadmap
Things I'd like to explore and add to `PlaygroundTester` (random order):
- Automatic `Package.swift` patching
- Filtering - by test result and by name
    - Possibly with persistence, to allow quick feedback for TDD
- Single test method / test suite execution
- Flat list view
- Assertion parity with `XCTest`
- Explore support for `async`/`await`
- Explore support for `Combine`
- ... and possibly more

Please check [Issues](https://github.com/Losiowaty/PlaygroundTester/issues) for more info.

------
