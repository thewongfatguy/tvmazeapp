import Models
import UIKit

public final class ShowsCoordinator {

  public let id = UUID()

  private var navigationController: UINavigationController!

  public init() {}

  public func start(in navigationController: UINavigationController) {
    self.navigationController = navigationController
    let showsListViewController = ShowsListViewController()

    showsListViewController.didSelectShow = { [weak self] show in
      self?.navigateToShowDetail(show)
    }

    navigationController.setViewControllers([showsListViewController], animated: false)
  }

  private func navigateToShowDetail(_ show: Show) {
    let controller = ShowDetailViewController(viewModel: ShowDetailViewModel(show: show))
    controller.didTapShowAllEpisodes = { [weak self] in
      self?.navigateToEpisodesList(show.id)
    }

    navigationController.pushViewController(
      controller, animated: true)
  }

  public var navigateToEpisodesList: ((Id<Show>) -> Void)!
}
