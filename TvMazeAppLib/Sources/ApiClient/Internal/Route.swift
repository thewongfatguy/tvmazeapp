import Foundation
import Models

struct Route: CustomStringConvertible {
  let path: String
  let method: Method
  let query: [URLQueryItem]?

  enum Method: String {
    case get = "GET"
  }

  var description: String {
    var output = ""
    output += "\(method.rawValue) "
    output += path
    if let query = query {
      let str = query.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
      output += "?\(str)"
    }
    return output
  }
}

extension Route {
  func urlRequest(withBaseURL baseURL: URL) -> URLRequest {
    var url = baseURL.appendingPathComponent(path)
    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)

    if let query = query {
      let currentQuery = components?.queryItems ?? []
      components?.queryItems = currentQuery + query
    }

    if let finalURL = components?.url {
      url = finalURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    return request
  }
}

extension Route {

  /// GET /shows?page=<page>
  static func shows(_ page: Int) -> Route {
    Route(path: "/shows", method: .get, query: [URLQueryItem(name: "page", value: "\(page)")])
  }

  /// GET /search/shows?q=<term>
  static func searchShows(_ term: String) -> Route {
    Route(
      path: "/search/shows",
      method: .get,
      query: [
        URLQueryItem(name: "q", value: term)
      ]
    )
  }

  /// GET /shows/<showId>/episodes
  static func showsEpisodes(_ showId: Id<Show>) -> Route {
    Route(
      path: "/shows/\(showId.rawValue)/episodes",
      method: .get,
      query: nil
    )
  }
}
