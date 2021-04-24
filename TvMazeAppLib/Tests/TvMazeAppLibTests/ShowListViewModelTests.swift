import Combine
import TestSupport
import XCTest

@testable import ApiClient
@testable import TvMazeAppLib

final class ShowListViewModelTests: XCTestCase {

  func test_Refresh_ReturnsError() {
    Env = .failing

    struct _Error: Error, Equatable {}

    Env.apiClient.shows = { _ in Fail(error: _Error()).eraseToAnyPublisher() }

    let viewModel = ShowListViewModel()

    let events = await(viewModel.refresh())

    XCTAssertEqual(
      events,
      [
        .isRefreshing(true),
        .showsLoaded(.failure(_Error() as NSError), source: .refresh),
        .isRefreshing(false),
      ]
    )

    XCTAssertEqual(viewModel.currentPage, 0)
  }

  func test_Refresh_ReturnsShowList() {
    Env = .failing

    let show = Show(
      id: 1,
      name: "Game of Thrones",
      image: Show.Image(medium: URL(fileURLWithPath: ""))
    )

    Env.apiClient.shows = { _ in
      Just(FetchShowsResult(page: 0, result: [show]))
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }

    let viewModel = ShowListViewModel()
    let events = await(viewModel.refresh())

    XCTAssertEqual(
      events,
      [
        .isRefreshing(true),
        .showsLoaded(.success([ShowListViewModel.Output.Show(show: show)]), source: .refresh),
        .isRefreshing(false),
      ]
    )
  }

}

extension XCTestCase {

  func await<P: Publisher>(
    _ publisher: P,
    timeout: TimeInterval = 10,
    file: StaticString = #file,
    line: UInt = #line
  ) -> [P.Output] where P.Failure == Never {
    let expectation = self.expectation(description: "Awaiting publisher")

    var outputs: [P.Output] = []

    let cancellable =
      publisher
      .sink(
        receiveCompletion: { _ in
          expectation.fulfill()
        },
        receiveValue: { value in
          outputs.append(value)
        })

    waitForExpectations(timeout: timeout)
    cancellable.cancel()

    return outputs
  }
}
