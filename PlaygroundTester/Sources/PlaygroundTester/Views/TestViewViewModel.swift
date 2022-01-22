#if TESTING_ENABLED

import Foundation

protocol TestRunnerProtocol {
  func findTests(completion: @escaping () -> Void)
  func executeAllTests(onTestFinish: @escaping (TestResult) -> Void, completion: @escaping () -> Void)
  func gatherResults() -> ResultViewModel

  var totalSuites: Int { get }
  var totalMethods: Int { get }
}

final class TestViewViewModel: ObservableObject {

  enum State {
    case searchingForTests
    case executing(finished: Int, success: Int, failure: Int)
    case done
  }

  let runner: TestRunnerProtocol
  var results = ResultViewModel(suites: [])

  @Published var state: State = .searchingForTests
  var totalClasses: Int = 0
  var totalTests: Int = 0

  private var finished = 0
  private var success = 0
  private var failure = 0

  init(runner: TestRunnerProtocol = TestRunner()) {
    self.runner = runner
  }

  func start() {
    self.results = runner.gatherResults()
    self.runner.findTests { [weak self] in
      guard let self = self else { return }

      self.totalClasses = self.runner.totalSuites
      self.totalTests = self.runner.totalMethods

      self.state = .executing(finished: 0, success: 0, failure: 0)

      self.startExecuting()
    }
  }

  private func startExecuting() {
    self.runner.executeAllTests { [weak self] result in
      guard let self = self else { return }

      self.finished += 1
      switch result.isSuccess {
      case true: self.success += 1
      case false: self.failure += 1
      }

      self.state = .executing(finished: self.finished, success: self.success, failure: self.failure)
    } completion: { [weak self] in
      guard let self = self else { return }

      self.results = self.runner.gatherResults()
      self.state = .done
    }
  }
}

#endif
