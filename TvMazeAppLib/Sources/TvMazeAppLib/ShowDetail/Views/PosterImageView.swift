import UIKit

extension ShowDetailView {
  final class PosterImageView: BaseView {
    private lazy var imageView = with(UIImageView()) {
      $0.contentMode = .scaleAspectFill
      $0.kf.indicatorType = .activity
      $0.kf.setImage(with: posterURL)
    }

    private let posterURL: URL

    init(posterURL: URL) {
      self.posterURL = posterURL
      super.init()
    }

    override func setupViewHierarchy() {
      addSubview(imageView)
    }

    override func setupConstraints() {
      imageView.edgesToSuperview()
      imageView.heightToWidth(of: self, multiplier: 1.47)
    }

    override func additionalConfiguration() {
      backgroundColor = .secondarySystemBackground
    }
  }
}
