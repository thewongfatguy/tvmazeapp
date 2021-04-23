import Foundation
import ApiClient

public struct AppEnvironment {
  public var apiClient: ApiClient
}

#if DEBUG
  var Env = AppEnvironment(apiClient: .live)
#else
  let Env = AppEnvironment(apiClient: .live)
#endif
