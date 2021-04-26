import EpisodesFeature
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
    let episodesCoordinator = EpisodesCoordinator()
    coordinators[episodesCoordinator.id] = episodesCoordinator
    episodesCoordinator.start(in: rootNavigationController, forShowId: showId) {
      [weak self, id = episodesCoordinator.id] in
      self?.coordinators[id] = nil
    }
  }
}
