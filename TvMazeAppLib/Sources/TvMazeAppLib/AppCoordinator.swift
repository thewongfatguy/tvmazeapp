import UIKit

public final class AppCoordinator {

  private let window: UIWindow
  private let rootNavigationController = UINavigationController()

  public init(window: UIWindow) {
    self.window = window
  }

  public func start() {
    window.rootViewController = rootNavigationController
    rootNavigationController.setViewControllers([ShowsListViewController()], animated: false)
    window.makeKeyAndVisible()
  }
}
