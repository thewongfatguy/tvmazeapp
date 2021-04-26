import Helpers
import UIKit

extension ShowDetailView {
  final class GenresView: BaseView {
    private let scrollView = with(UIScrollView()) {
      $0.contentInset = .horizontal(20)
      $0.showsHorizontalScrollIndicator = false
    }

    private let stackView = with(UIStackView()) {
      $0.axis = .horizontal
      $0.spacing = 8
    }

    var genres: [String] = [] {
      didSet {
        stackView.subviews.forEach {
          stackView.removeArrangedSubview($0)
          $0.removeFromSuperview()
        }

        genres
          .map(GenresView.makeLabel(for:))
          .forEach { stackView.addArrangedSubview($0) }
      }
    }

    override func setupViewHierarchy() {
      addSubview(scrollView)
      scrollView.addSubview(stackView)
    }

    override func setupConstraints() {
      scrollView.edgesToSuperview()
      stackView.edgesToSuperview()
      stackView.height(to: self)
    }

    private static func makeLabel(for genre: String) -> UIView {
      let containerView = UIView()
      containerView.backgroundColor = .secondarySystemBackground
      containerView.layer.cornerRadius = 4
      containerView.layer.masksToBounds = true

      let label = UILabel()
      label.text = genre
      label.font = .preferredFont(forTextStyle: .headline)
      containerView.addSubview(label)
      label.edgesToSuperview(insets: .uniform(4))

      return containerView
    }
  }
}
