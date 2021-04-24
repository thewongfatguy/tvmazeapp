import ApiClient
import Combine
import Foundation
import PaginationSink

final class ShowListViewModel {

  private(set) var currentPage = 0
  private(set) var isInSearchMode = false

  enum Output: Equatable {
    case showsLoaded(Result<[Show], NSError>, source: LoadSource)
    case isLoadingNextPage(Bool)
    case isRefreshing(Bool)

    struct Show: Hashable {
      let name: String
      let posterImage: URL?
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
        shows.result.map(Output.Show.init)
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
        shows.result.map(Output.Show.init)
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
        shows.map { Output.Show(show: $0.show) }
      }
      .mapError { $0 as NSError }
      .mapToResult()
      .map { Output.showsLoaded($0, source: .search) }

    return shows.eraseToAnyPublisher()
  }
}

extension ShowListViewModel.Output.Show {
  init(show: Show) {
    self.init(name: show.name, posterImage: show.image?.medium)
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
