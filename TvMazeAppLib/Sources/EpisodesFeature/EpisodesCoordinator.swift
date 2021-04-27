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
    navigationController.pushViewController(controller, animated: true)
  }
}
