import Combine
import XCTest

@testable import TvMazeApiClient
@testable import TvMazeAppLib

func withEnv(
  _ update: (inout AppEnvironment) -> Void,
  execute: () -> Void
) {
  let oldEnv = Env
  update(&Env)
  execute()
  Env = oldEnv
}

extension AppEnvironment {
  static var failing: Self {
    Self(
      apiClient: .failing
    )
  }
}

extension TvMazeApiClient {
  static var failing: Self {
    Self(
      shows: {
        XCTFail("\(Self.self).shows(\($0)) is not implemented.")
        return Empty().eraseToAnyPublisher()
      },
      searchShows: {
        XCTFail("\(Self.self).searchShows(\($0)) is not implemented.")
        return Empty().eraseToAnyPublisher()
      }
    )
  }
}
