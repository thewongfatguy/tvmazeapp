import Combine
import TvMazeApiClient
import UIKit

final class ShowsListViewController: UICollectionViewController {

  private var shows: [Show] = []
  private var bag = Set<AnyCancellable>()

  init() {
    let layout = UICollectionViewFlowLayout()

    let width = (UIScreen.main.bounds.width - 60) / 2
    layout.itemSize = CGSize(
      width: (UIScreen.main.bounds.width - 60) / 2,
      height: width * 16 / 9
    )
    layout.minimumLineSpacing = 20
    layout.minimumInteritemSpacing = 20
    layout.sectionInset = .init(top: 20, left: 20, bottom: 20, right: 20)

    super.init(collectionViewLayout: layout)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.backgroundColor = .white
    title = "TvMaze App"

    collectionView.register(
      ShowItemCell.self, forCellWithReuseIdentifier: ShowItemCell.reuseIdentifier)

    Env.apiClient.shows(0)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { completion in dump(completion) },
        receiveValue: { shows in
          self.shows = shows
          self.collectionView.reloadData()
        }
      )
      .store(in: &bag)
  }

  override func collectionView(
    _ collectionView: UICollectionView, numberOfItemsInSection section: Int
  ) -> Int {
    shows.count
  }

  override func collectionView(
    _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell =
      collectionView.dequeueReusableCell(
        withReuseIdentifier: ShowItemCell.reuseIdentifier, for: indexPath) as! ShowItemCell
    cell.nameLabel.text = shows[indexPath.item].name
    return cell
  }
}

extension UICollectionViewCell {
  class var reuseIdentifier: String { "\(Self.self)" }
}
