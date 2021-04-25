import UIKit

final class SeparatorView: BaseView {

  override func setupConstraints() {
    height(1)
  }

  override func additionalConfiguration() {
    backgroundColor = .secondarySystemBackground
  }
}
