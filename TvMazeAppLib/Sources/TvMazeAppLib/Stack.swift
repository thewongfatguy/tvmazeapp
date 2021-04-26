import UIKit

protocol Stackable {
  var rootView: UIView { get }
}

extension UIView: Stackable {
  var rootView: UIView { self }
}

final class Stack: Stackable {
  var rootView: UIView { stackView }

  private let stackView = UIStackView()

  init(
    axis: NSLayoutConstraint.Axis,
    spacing: CGFloat,
    alignment: UIStackView.Alignment,
    _ views: [Stackable]
  ) {
    stackView.axis = axis
    stackView.spacing = spacing
    stackView.alignment = alignment
    views.forEach {
      stackView.addArrangedSubview($0.rootView)
    }
  }

  convenience init(
    axis: NSLayoutConstraint.Axis,
    spacing: CGFloat,
    alignment: UIStackView.Alignment,
    _ views: Stackable...
  ) {
    self.init(axis: axis, spacing: spacing, alignment: alignment, views)
  }

  static func horizontal(
    alignment: UIStackView.Alignment = .fill,
    spacing: CGFloat = 8,
    _ views: [Stackable]
  ) -> Stack {
    Stack(axis: .horizontal, spacing: spacing, alignment: alignment, views)
  }

  static func vertical(
    alignment: UIStackView.Alignment = .fill,
    spacing: CGFloat = 8,
    _ views: [Stackable]
  ) -> Stack {
    Stack(axis: .vertical, spacing: spacing, alignment: alignment, views)
  }

  static func horizontal(
    alignment: UIStackView.Alignment = .fill,
    spacing: CGFloat = 8,
    _ views: Stackable...
  ) -> Stack {
    horizontal(alignment: alignment, spacing: spacing, views)
  }

  static func vertical(
    alignment: UIStackView.Alignment = .fill,
    spacing: CGFloat = 8,
    _ views: Stackable...
  ) -> Stack {
    vertical(alignment: alignment, spacing: spacing, views)
  }
}
