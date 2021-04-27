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
          .map { genre in
            with(ChipView()) {
              $0.text = genre
            }
          }
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
  }
}
