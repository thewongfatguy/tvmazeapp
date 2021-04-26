import Combine
import Foundation
import Models

struct EpisodesListViewModel {

  var fetchEpisodes: () -> AnyPublisher<Output, Never>

  enum Output: Equatable {
    case episodesLoaded(Result<[EpisodeDisplay], NSError>)
    case isLoading(Bool)

    struct EpisodeDisplay: Hashable {
      let episode: Episode

      var name: String { episode.name }
      var imageURL: URL? { episode.image?.medium }
      var summary: String? { episode.summary?.removingHTMLTags() }
    }
  }

}

extension EpisodesListViewModel {
  static func `default`(forShowId showId: Id<Show>) -> EpisodesListViewModel {
    let vm = _EpisodesListViewModel(showId: showId)
    return EpisodesListViewModel(fetchEpisodes: vm.fetchEpisodes)
  }
}

private struct _EpisodesListViewModel {

  let showId: Id<Show>

  typealias Output = EpisodesListViewModel.Output

  func fetchEpisodes() -> AnyPublisher<Output, Never> {
    let episodes = Env.apiClient.fetchEpisodes(showId)
      .map { episodes in
        episodes.map(Output.EpisodeDisplay.init(episode:))
      }
      .mapError { $0 as NSError }
      .mapToResult()
      .map(Output.episodesLoaded)

    return Just(.isLoading(true))
      .append(episodes)
      .append(.isLoading(false))
      .eraseToAnyPublisher()
  }
}
