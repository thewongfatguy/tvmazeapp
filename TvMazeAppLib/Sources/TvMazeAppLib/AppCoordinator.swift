import UIKit

public final class AppCoordinator {

  private let window: UIWindow

  public init(window: UIWindow) {
    self.window = window
  }

  public func start() {
    window.rootViewController = UIViewController()
    window.makeKeyAndVisible()
  }
}
