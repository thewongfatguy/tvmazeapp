import ApiClient
import Foundation

public struct AppEnvironment {
  public var apiClient: ApiClient
}

#if DEBUG
  public var Env = AppEnvironment(apiClient: .live)
#else
  public let Env = AppEnvironment(apiClient: .live)
#endif
