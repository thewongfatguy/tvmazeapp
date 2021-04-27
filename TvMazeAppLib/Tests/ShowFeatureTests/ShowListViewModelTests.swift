import AppEnvironment
import Combine
import TestSupport
import XCTest

@testable import ApiClient
@testable import Models
@testable import ShowFeature

final class ShowListViewModelTests: XCTestCase {

  var viewModel: ShowListViewModel!

  override func setUp() {
    Env = .failing

    viewModel = ShowListViewModel.default
  }

  func test_Refresh_ReturnsError() {
    struct _Error: Error, Equatable {}

    Env.apiClient.shows = { _ in Fail(error: _Error()).eraseToAnyPublisher() }

    let events = await(viewModel.refresh())

    XCTAssertEqual(
      events,
      [
        .isRefreshing(true),
        .showsLoaded(.failure(_Error() as NSError), source: .refresh),
        .isRefreshing(false),
      ]
    )

    // TODO:
    //    XCTAssertEqual(viewModel.currentPage, 0)
  }

  func test_Refresh_ReturnsShowList() {
    let show = Show.stub()

    Env.apiClient.shows = { _ in
      Just(FetchShowsResult.stub(page: 0, result: [show]))
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }

    let events = await(viewModel.refresh())

    XCTAssertEqual(
      events,
      [
        .isRefreshing(true),
        .showsLoaded(
          .success([ShowListViewModel.Output.ShowDisplay(show: show)]), source: .refresh),
        .isRefreshing(false),
      ]
    )
  }

  func test_LoadNextPage_ReturnsShowList() {
    let show = Show.stub()
    Env.apiClient.shows = { page in
      Just(FetchShowsResult.stub(page: page, result: [show]))
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }

    let events = await(viewModel.loadNextPage())

    XCTAssertEqual(
      events,
      [
        .isLoadingNextPage(true),
        .showsLoaded(
          .success([ShowListViewModel.Output.ShowDisplay(show: show)]), source: .loadNextPage),
        .isLoadingNextPage(false),
      ]
    )
  }

  func test_LoadNextPage_ReturnsError() {
    struct _Error: Error, Equatable {}

    Env.apiClient.shows = { _ in
      Fail(error: _Error())
        .eraseToAnyPublisher()
    }

    let events = await(viewModel.loadNextPage())

    XCTAssertEqual(
      events,
      [
        .isLoadingNextPage(true),
        .showsLoaded(.failure(_Error() as NSError), source: .loadNextPage),
        .isLoadingNextPage(false),
      ]
    )
  }

  func test_Search_WithEmptyTerm_ShouldReturnNothing() {
    let events = await(viewModel.search(""))
    XCTAssertTrue(events.isEmpty)
  }

  func test_Search_ShouldReturnListOfShows() {
    Env.apiClient.searchShows = { _ in
      Just([ShowSearch(score: 1, show: .stub())])
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }

    let events = await(viewModel.search("game of"))
    XCTAssertEqual(
      events,
      [
        .showsLoaded(.success([.init(show: .stub())]), source: .search)
      ]
    )
    // TODO:
    //    XCTAssertTrue(viewModel.isInSearchMode)
  }

  func test_Search_ReturnsError() {
    struct _Error: Error, Equatable {}

    Env.apiClient.searchShows = { _ in
      Fail(error: _Error())
        .eraseToAnyPublisher()
    }

    let events = await(viewModel.search("game of"))
    XCTAssertEqual(
      events,
      [
        .showsLoaded(.failure(_Error() as NSError), source: .search)
      ]
    )

    // TODO:
    //    XCTAssertTrue(viewModel.isInSearchMode)
  }

  func test_Refresh_ShouldSetSearchModeToFalse() {
    //    Env.apiClient.searchShows = { _ in Empty().eraseToAnyPublisher() }
    //    _ = await(viewModel.search("game of"))
    //    XCTAssertTrue(viewModel.isInSearchMode)
    //
    //    Env.apiClient.shows = { _ in Empty().eraseToAnyPublisher() }
    //    _ = await(viewModel.refresh())
    //    XCTAssertFalse(viewModel.isInSearchMode)
  }
}

extension Show {
  static func stub(
    id: Int = 1,
    name: String = "Game of Thrones",
    url: URL = URL(fileURLWithPath: ""),
    genres: [String]? = ["Drama"],
    schedule: Schedule? = .init(time: "22:00", days: ["Sunday"]),
    image: Image = Image(
      medium: URL(fileURLWithPath: ""), original: URL(fileURLWithPath: "")),
    summary: String? = "This is a summary"
  ) -> Show {
    Show(
      id: Id(rawValue: id),
      url: url,
      name: name,
      genres: genres,
      schedule: schedule,
      image: image,
      summary: summary
    )
  }
}

extension FetchShowsResult {
  static func stub(page: Int = 1, result: [Show] = [.stub()]) -> FetchShowsResult {
    FetchShowsResult(page: page, result: result)
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
