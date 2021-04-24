import ApiClient
import Combine
import UIKit

final class ShowsListViewController: UICollectionViewController {

  // MARK: - Types

  private enum Section: Hashable {
    case main
  }

  private typealias DataSource = UICollectionViewDiffableDataSource<
    Section, ShowListViewModel.Output.Show
  >
  private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ShowListViewModel.Output.Show>

  private let refreshControl = UIRefreshControl()

  static func makeCollectionViewLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.48),
      heightDimension: .fractionalHeight(1.0)
    )

    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(230)
    )

    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    group.interItemSpacing = NSCollectionLayoutSpacing.flexible(8)
    group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
      leading: nil, top: nil, trailing: nil, bottom: .fixed(20))

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }

  private let viewModel: ShowListViewModel
  private var bag = Set<AnyCancellable>()

  private lazy var dataSource = DataSource(collectionView: collectionView) {
    collectionView, indexPath, show -> UICollectionViewCell? in
    let cell =
      collectionView.dequeueReusableCell(
        withReuseIdentifier: ShowItemCell.reuseIdentifier, for: indexPath) as! ShowItemCell
    cell.bind(to: show)
    return cell
  }

  init(viewModel: ShowListViewModel = .init()) {
    self.viewModel = viewModel
    super.init(collectionViewLayout: Self.makeCollectionViewLayout())
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private let refreshSubject = PassthroughSubject<Void, Never>()
  private let loadNextPageSubject = PassthroughSubject<Void, Never>()

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.backgroundColor = .systemBackground
    title = "TvMaze App"

    collectionView.register(
      ShowItemCell.self, forCellWithReuseIdentifier: ShowItemCell.reuseIdentifier)
    collectionView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(refresh), for: .primaryActionTriggered)

    refresh()
  }

  @objc
  private func refresh() {
    viewModel.refresh()
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] in self?.handleViewModelOutput($0) })
      .store(in: &bag)
  }

  private func handleViewModelOutput(_ output: ShowListViewModel.Output) {
    switch output {
    case .showsLoaded(.success(let shows)):
      var snapshot = Snapshot()
      snapshot.appendSections([.main])
      snapshot.appendItems(shows)
      dataSource.apply(snapshot)

    case .showsLoaded(.failure(let error)):
      // TODO: handle error
      break

    case .isRefreshing(true):
      refreshControl.beginRefreshing()

    case .isRefreshing(false):
      refreshControl.endRefreshing()

    case .isLoadingNextPage(_):
      break
    }
  }
}

extension UICollectionViewCell {
  class var reuseIdentifier: String { "\(Self.self)" }
}
