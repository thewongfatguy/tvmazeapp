import Helpers
import L10n
import UIKit

extension ShowDetailView {
  final class SummaryView: BaseView {

    private let titleLabel = with(UILabel()) {
      $0.text = L10n.GameFeature.Detail.summary
      $0.font = .preferredFont(forTextStyle: .headline)
    }

    private lazy var summaryLabel = with(UILabel()) {
      $0.numberOfLines = 0
      $0.attributedText = summary.htmlAttributedString()
    }

    let summary: String

    init(summary: String) {
      self.summary = summary
      super.init()
    }

    override func setupViewHierarchy() {
      addSubview(titleLabel)
      addSubview(summaryLabel)
    }

    override func setupConstraints() {
      titleLabel.edgesToSuperview(excluding: .bottom, insets: .uniform(20))
      summaryLabel.edgesToSuperview(excluding: .top, insets: .uniform(20))

      titleLabel.bottomToTop(of: summaryLabel, offset: -8)
    }
  }

}
