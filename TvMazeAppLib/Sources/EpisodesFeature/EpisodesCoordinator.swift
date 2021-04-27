import Helpers
import Models
import UIKit

public final class EpisodesCoordinator: Coordinator {

  private let navigationController: UINavigationController
  private let showId: Id<Show>

  public init(in navigationController: UINavigationController, forShowId showId: Id<Show>) {
    self.navigationController = navigationController
    self.showId = showId
  }

  public override func start() {
    let controller = EpisodesListViewController(viewModel: .default(forShowId: showId))
    controller.didFinish = didFinish
    controller.didTapShareEpisode = { [weak self] episode in
      self?.presentShareActivity(episode.url)
    }
    navigationController.pushViewController(controller, animated: true)
  }

  private func presentShareActivity(_ url: URL) {
    let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
    navigationController.present(controller, animated: true)
  }
}
