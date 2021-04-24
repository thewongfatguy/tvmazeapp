import Combine
import TestSupport
import XCTest

@testable import TvMazeAppLib

//import ApiClient

final class ShowListViewModelTests: XCTestCase {

  func test_RequestError() {
    Env = .failing

    struct _Error: Error, Equatable {}

    Env.apiClient.shows = { _ in Fail(error: _Error()).eraseToAnyPublisher() }
    assertShowListViewModel(
      commands: {
        $0.refresh.send()
      },
      assertions: [
        .isRefreshing(false),
        .isLoadingNextPage(false),
        .isRefreshing(true),
        .error(_Error() as NSError),
        //                .shows([])
      ]
    )
  }

}

private enum ShowListViewModelEvents: Equatable {
  case shows([ShowListViewModel.Output.Show])
  case isRefreshing(Bool)
  case isLoadingNextPage(Bool)
  case error(NSError)
}

private struct ShowListViewModelTestsInputs {
  let refresh = PassthroughSubject<Void, Never>()
  let loadNextPage = PassthroughSubject<Void, Never>()
}

private func assertShowListViewModel(
  file: StaticString = #file,
  line: UInt = #line,
  commands: @escaping (ShowListViewModelTestsInputs) -> Void,
  assertions: [ShowListViewModelEvents]
) {
  let viewModel = ShowListViewModel.default
  let input = ShowListViewModelTestsInputs()
  let output = viewModel.transform(
    .init(
      refresh: input.refresh.eraseToAnyPublisher(),
      loadNextPage: input.loadNextPage.eraseToAnyPublisher()
    )
  )

  let publisher = Publishers.Merge4(
    output.shows.map(ShowListViewModelEvents.shows),
    output.isRefreshing.map(ShowListViewModelEvents.isRefreshing),
    output.isLoadingNextPage.map(ShowListViewModelEvents.isLoadingNextPage),
    output.error.map { $0 as NSError }.map(ShowListViewModelEvents.error)
  )

  assertPublisherEvents(
    file: file,
    line: line,
    publisher: publisher.eraseToAnyPublisher(),
    trigger: { commands(input) },
    assertions: assertions
  )
}
