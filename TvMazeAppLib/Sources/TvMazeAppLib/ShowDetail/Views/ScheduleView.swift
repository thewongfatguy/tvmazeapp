import UIKit

extension ShowDetailView {
  final class ScheduleView: BaseView {

    typealias ViewModel = [ShowDetailViewModel.ShowDetail.ScheduleItem]

    let viewModel: ViewModel

    init(viewModel: ViewModel) {
      self.viewModel = viewModel
      super.init()
    }

    private let containerView = UIView()

    private let scrollView = with(UIScrollView()) {
      $0.showsHorizontalScrollIndicator = false
      $0.contentInset = .horizontal(20)
    }

    private let stackView = with(UIStackView()) {
      $0.axis = .horizontal
      $0.spacing = 8
    }

    override func setupViewHierarchy() {
      addSubview(containerView)
      containerView.addSubview(scrollView)
      scrollView.addSubview(stackView)

      viewModel
        .map(ScheduleView.makeView(for:))
        .forEach(stackView.addArrangedSubview(_:))
    }

    override func setupConstraints() {
      containerView.edgesToSuperview()
      scrollView.edgesToSuperview(insets: .vertical(20))
      stackView.edgesToSuperview()
      stackView.heightToSuperview()
    }

    private static func makeView(for item: ViewModel.Element) -> UIView {
      let container = UIView()

      container.backgroundColor = item.isHighlighted ? .systemBlue : .secondarySystemBackground
      container.layer.cornerRadius = 4
      container.layer.masksToBounds = true

      let dayLabel = UILabel()
      dayLabel.text = item.day
      dayLabel.font = .preferredFont(forTextStyle: .headline)

      let timeLabel = UILabel()
      timeLabel.text = item.time
      timeLabel.font = .preferredFont(forTextStyle: .headline)

      container.addSubview(dayLabel)
      container.addSubview(timeLabel)

      dayLabel.edgesToSuperview(excluding: .bottom, insets: .uniform(4))
      timeLabel.edgesToSuperview(excluding: .top, insets: .uniform(4))

      dayLabel.bottomToTop(of: timeLabel, offset: -4)

      return container
    }
  }
}
