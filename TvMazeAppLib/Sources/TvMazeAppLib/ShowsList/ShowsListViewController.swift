import ApiClient
import Combine
import Models
import UIKit

final class ShowsListViewController: UICollectionViewController {

  // MARK: - Types

  private enum Section: Hashable {
    case main
  }

  private typealias DataSource = UICollectionViewDiffableDataSource<
    Section, ShowListViewModel.Output.ShowDisplay
  >
  private typealias Snapshot = NSDiffableDataSourceSnapshot<
    Section, ShowListViewModel.Output.ShowDisplay
  >

  private let refreshControl = UIRefreshControl()
  private lazy var searchController = with(UISearchController(searchResultsController: nil)) {
    $0.searchBar.autocapitalizationType = .none
    $0.searchBar.delegate = self
    $0.delegate = self
    $0.obscuresBackgroundDuringPresentation = false
  }

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
        withReuseIdentifier: ShowItemCell.reuseIdentifier, for: indexPath) as? ShowItemCell
    cell?.bind(to: show)
    return cell
  }

  init(viewModel: ShowListViewModel = .default) {
    self.viewModel = viewModel
    super.init(collectionViewLayout: Self.makeCollectionViewLayout())

    definesPresentationContext = true
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.backgroundColor = .systemBackground
    title = "TvMaze App"

    collectionView.register(
      ShowItemCell.self, forCellWithReuseIdentifier: ShowItemCell.reuseIdentifier)
    collectionView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(refresh), for: .primaryActionTriggered)
    navigationItem.searchController = searchController

    refresh()
  }

  @objc
  private func refresh() {
    viewModel.refresh()
      .handleUIChanges(on: self, with: ShowsListViewController.handleViewModelOutput)
      .store(in: &bag)
  }

  private func loadNextPage() {
    viewModel.loadNextPage()
      .handleUIChanges(on: self, with: ShowsListViewController.handleViewModelOutput)
      .store(in: &bag)
  }

  private func search(_ term: String) {
    viewModel.search(term)
      .handleUIChanges(on: self, with: ShowsListViewController.handleViewModelOutput)
      .store(in: &bag)
  }

  private func handleViewModelOutput(_ output: ShowListViewModel.Output) {
    switch output {
    case let .showsLoaded(.success(shows), .refresh),
      let .showsLoaded(.success(shows), .search):
      var snapshot = Snapshot()
      snapshot.appendSections([.main])
      snapshot.appendItems(shows)
      dataSource.apply(snapshot)

    case let .showsLoaded(.success(shows), .loadNextPage):
      var snapshot = dataSource.snapshot()
      snapshot.appendItems(shows, toSection: .main)
      dataSource.apply(snapshot)

    case .showsLoaded(.failure(_), _):
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

  override func collectionView(
    _ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    let numberOfItems = collectionView.numberOfItems(inSection: 0)
    if indexPath.item == numberOfItems - 1 {
      loadNextPage()
    }
  }

  override func collectionView(
    _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath
  ) {
    guard let show = dataSource.itemIdentifier(for: indexPath) else {
      return
    }

    didSelectShow(show.show)
  }

  var didSelectShow: ((Show) -> Void)!
}

extension UICollectionViewCell {
  class var reuseIdentifier: String { "\(Self.self)" }
}

// MARK: - UISearchBarDelegate

extension ShowsListViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    search(searchBar.text ?? "")
  }
}

// MARK: - UISearchControllerDelegate

extension ShowsListViewController: UISearchControllerDelegate {
  func didDismissSearchController(_ searchController: UISearchController) {
    refresh()
  }
}

extension Publisher where Failure == Never {

  func handleUIChanges<O: AnyObject>(on object: O, with handler: @escaping (O) -> (Output) -> Void)
    -> AnyCancellable
  {
    receive(on: DispatchQueue.main)
      .sink { [weak object] output in
        guard let object = object else {
          return
        }

        let apply = handler(object)
        apply(output)
      }
  }
}
