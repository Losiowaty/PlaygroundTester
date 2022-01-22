[![Swift](https://github.com/Losiowaty/PlaygroundTester/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/Losiowaty/PlaygroundTester/actions/workflows/swift.yml)

# PlaygroundTester

# Version 0.1 
- [ ] Basic assertions
- [ ] Obj-C approach with extension
- [ ] Basic visualizer - list + filter all/failed tests

# TODO list :  
## Assertion methods
- [ ] Global functions?
- [ ] Need to inform base store of result
- [ ] Support async tests (expctations, waiting)
- [ ] Support throwing test functions
- [ ] Accept #function as default param to print name? (not needed I think)
- [ ] Check if possible to integrate Point Free Xcode warnings to show failures inline? 

## Tester class
- [ ] Base interface to extend to provide test methods
- [ ] Generic KV store?
- [ ] Support subclassing?
- [ ] Sorted / randomized execution
- [ ] Filter only methods with `test` in name
- [ ] `test_FirstSegment_name` -> Treat `FirstSegment` as grouping name
- [ ] Runs tests in background?

## Visualiser
- [ ] SwiftUI
- [ ] Displays progress
- [ ] Displays tests results
- [ ] Fitlering by name
- [ ] Filtering by result
- [ ] Provide view to be displayed in `App` context

# Wild ideas

- Top level method exposed to Obj-C, nested methods runing actual tests?
