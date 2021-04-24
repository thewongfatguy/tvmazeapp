import Combine
import Foundation
import Logging

private let logger = Logger(label: "dev.grds.tvmazeapp.apiclient")

public struct FetchShowsResult {
  public let page: Int
  public let result: [Show]
}

public struct ApiClient {
  public var shows: (Int) -> AnyPublisher<FetchShowsResult, Error>
  public var searchShows: (String) -> AnyPublisher<[ShowSearch], Error>
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
    let request = route.urlRequest(withBaseURL: baseURL)
    return URLSession.shared
      .dataTaskPublisher(for: request)
      .handleEvents(
        receiveSubscription: { _ in
          #if DEBUG
            logger.info("->> \(route)")
          #endif
        },
        receiveOutput: { _, response in
          #if DEBUG
            let httpResponse = response as! HTTPURLResponse
            let status = httpResponse.statusCode

            logger.info("<<- \(route) - status=\(status)")
          #endif
        },
        receiveCompletion: { completion in
          #if DEBUG
            if case let .failure(error) = completion {
              logger.info("request error: \(error)")
            }
          #endif
        }
      )
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
      .tryMap { data, _ in
        #if DEBUG
          do {
            return try JSONDecoder().decode(A.self, from: data)
          } catch {
            logger.error("error decoding type '\(A.self)': \(error)")
            throw error
          }
        #endif
      }
      .eraseToAnyPublisher()
  }
}
