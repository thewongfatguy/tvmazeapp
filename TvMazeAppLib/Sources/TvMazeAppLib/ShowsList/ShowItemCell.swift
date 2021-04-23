import Kingfisher
import TinyConstraints
import UIKit

func with<A>(_ object: A, apply: (inout A) -> Void) -> A {
  var copy = object
  apply(&copy)
  return copy
}

final class ShowItemCell: UICollectionViewCell {

  struct ViewModel {
    let name: String
    let posterImageURL: URL
  }

  private let posterImageView = with(UIImageView()) {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.kf.indicatorType = .activity
  }

  private let nameOverlayView = with(UIView()) {
    $0.backgroundColor = UIColor.black.withAlphaComponent(0.7)
  }

  private let nameLabel = with(UILabel()) {
    $0.numberOfLines = 1
    $0.font = .preferredFont(forTextStyle: .headline)
    $0.textColor = .white

    $0.text = "Example name"
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViewHierarchy()
    setupLayoutConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    posterImageView.kf.cancelDownloadTask()
    nameLabel.text = nil
  }

  func bind(to viewModel: ViewModel) {
    posterImageView.kf.setImage(with: viewModel.posterImageURL)
    nameLabel.text = viewModel.name
  }

  private func setupViewHierarchy() {
    contentView.addSubview(posterImageView)
    contentView.addSubview(nameOverlayView)
    nameOverlayView.addSubview(nameLabel)
  }

  private func setupLayoutConstraints() {
    posterImageView.edgesToSuperview()
    nameOverlayView.edgesToSuperview(excluding: .top)
    nameLabel.edgesToSuperview(insets: .uniform(12))
  }
}
