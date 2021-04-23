import TinyConstraints
import UIKit

func with<A>(_ object: A, apply: (inout A) -> Void) -> A {
  var copy = object
  apply(&copy)
  return copy
}

final class ShowItemCell: UICollectionViewCell {

  private let posterImageView = UIImageView()

  private let nameOverlayView = with(UIView()) {
    $0.backgroundColor = UIColor.black.withAlphaComponent(0.8)
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
