import Combine
import Foundation

public struct TvMazeApiClient {
  public var searchShows: (String) -> AnyPublisher<[ShowSearch], Error>
}

extension TvMazeApiClient {
  public static var live: Self {
    let baseURL = URL(string: "https://api.tvmaze.com")!

    return Self(
      searchShows: { term in
        TvMazeApiClient.apiRequest(
          baseURL: baseURL,
          route: .searchShows(term)
        )
        .apiDecoded()
      }
    )
  }
}

extension TvMazeApiClient {
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
