import EpisodesFeature
import Helpers
import Models
import ShowFeature
import UIKit

public final class AppCoordinator: Coordinator {

  private let window: UIWindow
  private let rootNavigationController = UINavigationController()

  public init(window: UIWindow) {
    self.window = window
  }

  public override func start() {
    window.rootViewController = rootNavigationController

    let showCoordinator = ShowsCoordinator(navigationController: rootNavigationController)
    showCoordinator.navigateToEpisodesList = navigateToEpisodesList
    coordinate(to: showCoordinator)

    window.makeKeyAndVisible()
  }

  private func navigateToEpisodesList(_ showId: Id<Show>) {
    let episodesCoordinator = EpisodesCoordinator(in: rootNavigationController, forShowId: showId)
    coordinate(to: episodesCoordinator)
  }
}
