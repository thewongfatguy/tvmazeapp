import ApiClient
import Combine
import Foundation
import PaginationSink

final class ShowListViewModel {

  private(set) var currentPage = 0

  enum Output: Equatable {
    case showsLoaded(Result<[Show], NSError>)
    case isLoadingNextPage(Bool)
    case isRefreshing(Bool)

    struct Show: Hashable {
      let name: String
      let posterImage: URL?
    }
  }

  func refresh() -> AnyPublisher<Output, Never> {
    currentPage = 0

    let shows = Env.apiClient.shows(currentPage)
      .map { shows in
        shows.result.map(Output.Show.init)
      }
      .mapError { $0 as NSError }
      .mapToResult()
      .map(Output.showsLoaded)

    return Just(.isRefreshing(true))
      .append(shows)
      .append(.isRefreshing(false))
      .eraseToAnyPublisher()
  }

  func loadNextPage() -> AnyPublisher<Output, Never> {
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
      .map(Output.showsLoaded)

    return Just(.isLoadingNextPage(true))
      .append(shows)
      .append(.isLoadingNextPage(false))
      .eraseToAnyPublisher()
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
