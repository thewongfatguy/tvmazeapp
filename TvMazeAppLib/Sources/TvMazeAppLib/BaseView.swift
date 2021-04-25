import UIKit

/// BaseView makes easier to build custom views.
class BaseView: UIView {
  init() {
    super.init(frame: .zero)
    setupViewHierarchy()
    setupConstraints()
    additionalConfiguration()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViewHierarchy() {
    // no-op
  }

  func setupConstraints() {
    // no-op
  }

  func additionalConfiguration() {
    // no-op
  }
}
