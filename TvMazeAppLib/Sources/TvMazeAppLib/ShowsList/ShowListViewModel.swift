import ApiClient
import Combine
import Foundation

final class ShowListViewModel {

  private(set) var currentPage = 0
  private(set) var isInSearchMode = false

  enum Output: Equatable {
    case showsLoaded(Result<[ShowDisplay], NSError>, source: LoadSource)
    case isLoadingNextPage(Bool)
    case isRefreshing(Bool)

    struct ShowDisplay: Hashable {
      static func == (
        lhs: ShowListViewModel.Output.ShowDisplay, rhs: ShowListViewModel.Output.ShowDisplay
      ) -> Bool {
        lhs.name == rhs.name && lhs.posterImage == rhs.posterImage
      }

      let show: Show

      var name: String { show.name }
      var posterImage: URL? { show.image?.medium }

      func hash(into hasher: inout Hasher) {
        name.hash(into: &hasher)
        posterImage?.hash(into: &hasher)
      }
    }

    enum LoadSource: Equatable {
      case refresh, loadNextPage, search
    }
  }

  func refresh() -> AnyPublisher<Output, Never> {
    currentPage = 0
    isInSearchMode = false

    let shows = Env.apiClient.shows(currentPage)
      .map { shows in
        shows.result.map(Output.ShowDisplay.init)
      }
      .mapError { $0 as NSError }
      .mapToResult()
      .map { Output.showsLoaded($0, source: .refresh) }

    return Just(.isRefreshing(true))
      .append(shows)
      .append(.isRefreshing(false))
      .eraseToAnyPublisher()
  }

  func loadNextPage() -> AnyPublisher<Output, Never> {
    // Loading next page is not supported when searching
    // as the search endpoint already returns all results in
    // a single fetch.
    guard !isInSearchMode else {
      return Empty().eraseToAnyPublisher()
    }

    let shows = Env.apiClient.shows(currentPage + 1)
      .handleEvents(receiveOutput: { [weak self] result in
        // updates current page on success
        self?.currentPage = result.page
      })
      .map { shows in
        shows.result.map(Output.ShowDisplay.init)
      }
      .mapError { $0 as NSError }
      .mapToResult()
      .map { Output.showsLoaded($0, source: .loadNextPage) }

    return Just(.isLoadingNextPage(true))
      .append(shows)
      .append(.isLoadingNextPage(false))
      .eraseToAnyPublisher()
  }

  func search(_ term: String) -> AnyPublisher<Output, Never> {
    guard term.isEmpty == false else {
      return Empty().eraseToAnyPublisher()
    }

    isInSearchMode = true

    let shows = Env.apiClient.searchShows(term)
      .map { shows in
        shows.map { Output.ShowDisplay(show: $0.show) }
      }
      .mapError { $0 as NSError }
      .mapToResult()
      .map { Output.showsLoaded($0, source: .search) }

    return shows.eraseToAnyPublisher()
  }
}

//
//extension Publisher where Failure: Error {
//  func forwardError<S>(to sink: S) -> AnyPublisher<Output, Never>
//  where S: Subject, S.Output == Failure, S.Failure == Never {
//    `catch` { error -> Empty<Output, Never> in
//      sink.send(error)
//      return Empty()
//    }.eraseToAnyPublisher()
//  }
//}
//
extension Publisher {
  func mapToResult() -> AnyPublisher<Result<Output, Failure>, Never> {
    map(Result.success)
      .catch { Just(.failure($0)) }
      .eraseToAnyPublisher()
  }
}
