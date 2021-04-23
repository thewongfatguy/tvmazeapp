import Foundation
import TvMazeApiClient

public struct AppEnvironment {
  public var apiClient: TvMazeApiClient
}

#if DEBUG
  var Env = AppEnvironment(apiClient: .live)
#else
  let Env = AppEnvironment(apiClient: .live)
#endif
