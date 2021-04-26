import Models
import UIKit

public final class EpisodesCoordinator {

  public let id = UUID()

  public init() {}

  public func start(
    in navigationController: UINavigationController, forShowId showId: Id<Show>,
    onCompletion: @escaping () -> Void
  ) {
    let controller = EpisodesListViewController(viewModel: .default(forShowId: showId))
    controller.didFinish = onCompletion
    navigationController.pushViewController(controller, animated: true)
  }
}
