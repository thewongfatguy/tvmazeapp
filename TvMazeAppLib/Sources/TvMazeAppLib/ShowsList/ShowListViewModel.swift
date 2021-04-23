import ApiClient
import Combine
import Foundation
import PaginationSink

struct ShowListViewModel {
  struct Input {
    let refresh: AnyPublisher<Void, Never>
    let loadNextPage: AnyPublisher<Void, Never>
  }

  struct Output {
    var shows: AnyPublisher<[Show], Never>
    var isRefreshing: AnyPublisher<Bool, Never>
    var isLoadingNextPage: AnyPublisher<Bool, Never>
    var error: AnyPublisher<Error, Never>

    struct Show: Hashable {
      let name: String
      let posterImage: URL
    }
  }

  let transform: (Input) -> Output
}

extension ShowListViewModel {
  static let `default` = ShowListViewModel { input in

    let paginationSink = PaginationSink<Show, Error>.make(
      refreshTrigger: input.refresh,
      nextPageTrigger: input.loadNextPage,
      valuesFromEnvelope: \FetchShowsResult.result,
      cursorFromEnvelope: \FetchShowsResult.page,
      requestFromCursor: { Env.apiClient.shows($0).mapToResult() }
    )

    return Output(
      shows: paginationSink.values
        .map { shows in
          shows.map { show in Output.Show(name: show.name, posterImage: show.image.medium) }
        }
        .eraseToAnyPublisher(),
      isRefreshing: paginationSink.isRefreshing,
      isLoadingNextPage: paginationSink.isLoadingNextPage,
      error: paginationSink.error
    )
  }
}

extension Publisher where Failure: Error {
  func forwardError<S>(to sink: S) -> AnyPublisher<Output, Never>
  where S: Subject, S.Output == Failure, S.Failure == Never {
    `catch` { error -> Empty<Output, Never> in
      sink.send(error)
      return Empty()
    }.eraseToAnyPublisher()
  }
}

extension Publisher {
  func mapToResult() -> AnyPublisher<Result<Output, Failure>, Never> {
    map(Result.success)
      .catch { Just(.failure($0)) }
      .eraseToAnyPublisher()
  }
}
