import ApiClient
import Foundation

public struct AppEnvironment {
  public var apiClient: ApiClient

  public init(apiClient: ApiClient) {
    self.apiClient = apiClient
  }
}

#if DEBUG
  public var Env = AppEnvironment(apiClient: .live)
#else
  public let Env = AppEnvironment(apiClient: .live)
#endif
