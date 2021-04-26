import Helpers
import UIKit

extension ShowDetailView {
  final class TitleInfoView: BaseView {
    private lazy var nameLabel = with(UILabel()) {
      $0.font = .preferredFont(forTextStyle: .title2)
      $0.numberOfLines = 0
      $0.text = name
    }

    private lazy var genresView = GenresView()

    private let name: String
    private let genres: [String]?

    init(name: String, genres: [String]?) {
      self.name = name
      self.genres = genres
      super.init()
    }

    override func setupViewHierarchy() {
      addSubview(nameLabel)

      if let genres = genres {
        addSubview(genresView)
        genresView.genres = genres
      }
    }

    override func setupConstraints() {
      if genres != nil {
        nameLabel.edgesToSuperview(excluding: .bottom, insets: .uniform(20))
        genresView.edgesToSuperview(excluding: .top, insets: .bottom(20))
        nameLabel.bottomToTop(of: genresView, offset: -8)
      } else {
        nameLabel.edgesToSuperview(insets: .uniform(20))
      }
    }
  }
}
