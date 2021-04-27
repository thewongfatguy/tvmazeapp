import TinyConstraints
import UIKit

public final class ChipView: BaseView {
  public let label = with(UILabel()) {
    $0.font = .preferredFont(forTextStyle: .headline)
  }

  public var text: String? {
    get { label.text }
    set { label.text = newValue }
  }

    public var isSelected: Bool = false {
        didSet {
            backgroundColor = isSelected ? .systemBlue : .secondarySystemBackground
        }
    }

  override public func setupViewHierarchy() {
    addSubview(label)
  }

  override public func setupConstraints() {
    label.edgesToSuperview(insets: .uniform(4))
  }

  override public func additionalConfiguration() {
    backgroundColor = .secondarySystemBackground
    layer.cornerRadius = 4
    layer.masksToBounds = true
  }
}
