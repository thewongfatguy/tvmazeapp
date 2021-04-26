import UIKit

/// BaseView makes easier to build custom views.
open class BaseView: UIView {
  public init() {
    super.init(frame: .zero)
    setupViewHierarchy()
    setupConstraints()
    additionalConfiguration()
  }

  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open func setupViewHierarchy() {
    // no-op
  }

  open func setupConstraints() {
    // no-op
  }

  open func additionalConfiguration() {
    // no-op
  }
}
