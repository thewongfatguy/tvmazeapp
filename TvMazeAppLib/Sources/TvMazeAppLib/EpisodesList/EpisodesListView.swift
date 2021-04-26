import Helpers
import UIKit

final class EpisodesListView: BaseView {

  private enum Section: Hashable {
    case main
  }

  private typealias DataSource = UITableViewDiffableDataSource<
    Section, EpisodesListViewModel.Output.EpisodeDisplay
  >
  private typealias Snapshot = NSDiffableDataSourceSnapshot<
    Section, EpisodesListViewModel.Output.EpisodeDisplay
  >

  private let tableView = with(UITableView(frame: .zero, style: .plain)) {
    $0.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.reuseIdentifier)
    $0.rowHeight = 128
  }

  private lazy var dataSource = DataSource(tableView: tableView) {
    tableView, indexPath, episode -> UITableViewCell? in
    let cell =
      tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseIdentifier, for: indexPath)
      as? EpisodeCell
    cell?.bind(to: episode)
    return cell
  }

  override func setupViewHierarchy() {
    addSubview(tableView)
  }

  override func setupConstraints() {
    tableView.edgesToSuperview()
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
