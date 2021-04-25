//
//  File.swift
//
//
//  Created by Guilherme Souza on 23/04/21.
//

import SnapshotTesting
import XCTest

@testable import ApiClient

final class RouteTest: XCTestCase {

  let baseURL = URL(string: "https://api.tvmaze.com")!

  func test_Build_ShowsRoute() {
    let route = Route.shows(10)
    let request = route.urlRequest(withBaseURL: baseURL)
    assertSnapshot(matching: request, as: .raw)
  }

  func test_Build_SearchShowsRoute() {
    let route = Route.searchShows("girl")
    let request = route.urlRequest(withBaseURL: baseURL)
    assertSnapshot(matching: request, as: .raw)
  }

  func test_Build_ShowsEpisodesRoute() {
    let route = Route.showsEpisodes(1)
    let request = route.urlRequest(withBaseURL: baseURL)
    assertSnapshot(matching: request, as: .raw)
  }
}
