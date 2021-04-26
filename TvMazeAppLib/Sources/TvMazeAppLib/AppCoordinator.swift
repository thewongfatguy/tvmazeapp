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
    let controller = ShowDetailViewController(viewModel: ShowDetailViewModel(show: show))
    controller.didTapShowAllEpisodes = { [weak self] in
      self?.navigateToEpisodesList(show.id)
    }

    rootNavigationController.pushViewController(
      controller, animated: true)
  }

  private func navigateToEpisodesList(_ showId: Id<Show>) {
    rootNavigationController.pushViewController(
      EpisodesListViewController(viewModel: .default(forShowId: showId)), animated: true)
  }
}
