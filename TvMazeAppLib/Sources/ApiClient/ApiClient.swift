import Combine
import Foundation

public struct FetchShowsResult {
  public let page: Int
  public let result: [Show]
}

public struct ApiClient {
  public var shows: (Int) -> AnyPublisher<FetchShowsResult, Error>
  public var searchShows: (String) -> AnyPublisher<[ShowSearch], Error>

  public init(
    shows: @escaping (Int) -> AnyPublisher<FetchShowsResult, Error>,
    searchShows: @escaping (String) -> AnyPublisher<[ShowSearch], Error>
  ) {
    self.shows = shows
    self.searchShows = searchShows
  }
}

extension ApiClient {
  public static var live: Self {
    let baseURL = URL(string: "https://api.tvmaze.com")!

    return Self(
      shows: { page in
        ApiClient
          .apiRequest(baseURL: baseURL, route: .shows(page))
          .apiDecoded(as: [Show].self)
          .map { shows in
            FetchShowsResult(page: page, result: shows)
          }
          .eraseToAnyPublisher()
      },
      searchShows: { term in
        ApiClient.apiRequest(
          baseURL: baseURL,
          route: .searchShows(term)
        )
        .apiDecoded()
      }
    )
  }
}

extension ApiClient {
  private static func apiRequest(
    baseURL: URL,
    route: Route
  ) -> AnyPublisher<
    (data: Data, response: URLResponse), URLError
  > {
    URLSession.shared
      .dataTaskPublisher(for: route.urlRequest(withBaseURL: baseURL))
      .eraseToAnyPublisher()
  }
}

extension Publisher where Output == (data: Data, response: URLResponse), Failure == URLError {
  func apiDecoded<A: Decodable>(
    as type: A.Type = A.self,
    file: StaticString = #file,
    line: UInt = #line
  ) -> AnyPublisher<A, Error> {
    self
      .mapError { $0 as Error }
      .tryMap { data, _ in try JSONDecoder().decode(A.self, from: data) }
      .eraseToAnyPublisher()
  }
}
