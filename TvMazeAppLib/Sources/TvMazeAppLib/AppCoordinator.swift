import Models
import ShowFeature
import UIKit

public final class AppCoordinator {

  private let window: UIWindow
  private let rootNavigationController = UINavigationController()

  private var coordinators: [UUID: AnyObject] = [:]

  public init(window: UIWindow) {
    self.window = window
  }

  public func start() {
    window.rootViewController = rootNavigationController

    let showCoordinator = ShowsCoordinator()
    coordinators[showCoordinator.id] = showCoordinator

    showCoordinator.navigateToEpisodesList = navigateToEpisodesList

    showCoordinator.start(in: rootNavigationController)

    window.makeKeyAndVisible()
  }

  private func navigateToEpisodesList(_ showId: Id<Show>) {
    rootNavigationController.pushViewController(
      EpisodesListViewController(viewModel: .default(forShowId: showId)), animated: true)
  }
}
