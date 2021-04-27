import Helpers
import Models
import UIKit

public final class ShowsCoordinator: Coordinator {

  private let navigationController: UINavigationController

  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  public override func start() {
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

    controller.didTapShareButton = { [weak self] in
      self?.presentShareActivity(show.url)
    }

    navigationController.pushViewController(
      controller, animated: true)
  }

  public var navigateToEpisodesList: ((Id<Show>) -> Void)!

  private func presentShareActivity(_ url: URL) {
    let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
    navigationController.present(controller, animated: true)
  }
}
