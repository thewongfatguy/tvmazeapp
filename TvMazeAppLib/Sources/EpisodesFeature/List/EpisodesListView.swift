import Helpers
import L10n
import UIKit

final class EpisodesListView: BaseView, UITableViewDelegate {

  private enum Section: Hashable {
    case main
  }

  private typealias DataSource = UITableViewDiffableDataSource<
    Section, EpisodesListViewModel.Output.EpisodeDisplay
  >
  private typealias Snapshot = NSDiffableDataSourceSnapshot<
    Section, EpisodesListViewModel.Output.EpisodeDisplay
  >

  private lazy var tableView = with(UITableView(frame: .zero, style: .plain)) {
    $0.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.reuseIdentifier)
    $0.rowHeight = 128
    $0.delegate = self
  }

  private lazy var dataSource = DataSource(tableView: tableView) {
    tableView, indexPath, episode -> UITableViewCell? in
    let cell =
      tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseIdentifier, for: indexPath)
      as? EpisodeCell
    cell?.bind(to: episode)
    return cell
  }

  var didTapShareEpisode: ((EpisodesListViewModel.Output.EpisodeDisplay) -> Void)!

  override func setupViewHierarchy() {
    addSubview(tableView)
  }

  override func setupConstraints() {
    tableView.edgesToSuperview()
  }

  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    false
  }

  func tableView(
    _ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint
  ) -> UIContextMenuConfiguration? {
    guard let episode = dataSource.itemIdentifier(for: indexPath) else {
      return nil
    }

    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
      let shareAction = UIAction(
        title: L10n.Common.share, image: UIImage(systemName: "square.and.arrow.up")
      ) { _ in
        self.didTapShareEpisode(episode)
      }

      return UIMenu(children: [shareAction])
    }
  }
}

extension EpisodesListView {
  func handleViewModelOutputs(_ output: EpisodesListViewModel.Output) {
    switch output {
    case .episodesLoaded(.success(let episodes)):
      var snapshot = Snapshot()
      snapshot.appendSections([.main])
      snapshot.appendItems(episodes, toSection: .main)
      dataSource.apply(snapshot, animatingDifferences: false)

    case .episodesLoaded(.failure(let error)):
      ()

    case .isLoading(true):
      ()

    case .isLoading(false):
      ()
    }
  }
}

extension UITableViewCell {
  class var reuseIdentifier: String { "\(Self.self)" }
}
