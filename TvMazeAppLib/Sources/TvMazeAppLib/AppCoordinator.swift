import Models
import UIKit

public final class AppCoordinator {

  private let window: UIWindow
  private let rootNavigationController = UINavigationController()

  public init(window: UIWindow) {
    self.window = window
  }

  public func start() {
    window.rootViewController = rootNavigationController

    let showsListViewController = ShowsListViewController()

    showsListViewController.didSelectShow = { [weak self] show in
      self?.navigateToShowDetail(show)
    }

    rootNavigationController.setViewControllers([showsListViewController], animated: false)
    window.makeKeyAndVisible()
  }

  private func navigateToShowDetail(_ show: Show) {
    rootNavigationController.pushViewController(
      ShowDetailViewController(viewModel: ShowDetailViewModel(show: show)), animated: true)
  }
}
