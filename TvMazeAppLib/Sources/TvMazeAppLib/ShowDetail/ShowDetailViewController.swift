import UIKit

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

final class ShowDetailViewController: UICollectionViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func loadView() {
    view = ShowDetailView()
  }
}

final class ShowDetailView: BaseView {

  private let scrollView = with(UIScrollView()) {
    $0.contentInsetAdjustmentBehavior = .always
  }

  private let mainHorizontalStackView = with(UIStackView()) {
    $0.axis = .vertical
  }

  private let posterImageView = PosterImageView()
  private let titleInfoView = TitleInfoView()

  override func setupViewHierarchy() {
    addSubview(scrollView)
    scrollView.addSubview(mainHorizontalStackView)

    mainHorizontalStackView.addArrangedSubview(posterImageView)
    mainHorizontalStackView.addArrangedSubview(separator())
    mainHorizontalStackView.addArrangedSubview(titleInfoView)
    mainHorizontalStackView.addArrangedSubview(separator())

    mainHorizontalStackView.addArrangedSubview(
      ScheduleView(
        viewModel: ScheduleView.ViewModel(
          schedule: ScheduleView.ViewModel.Schedule(time: "22:00", days: ["Sunday", "Wednesday"]))))

    mainHorizontalStackView.addArrangedSubview(separator())

    mainHorizontalStackView.addArrangedSubview(
      SummaryView(
        summary:
          "<p>From creators Mara Brock Akil and Kelsey Grammer, comes a comedy about three special woman, each in a relationship with one of three hard-working football players. Melanie is trying to work her relationship with Derwin, her boyfriend, while Tasha Mack balances the relationship she has with her son, Malik and with her job. Kelly and Jason are also working hard to make their relationship last.<br><b>The Game</b> focuses on each of the relationships present in these women's lives -- those with both friends and lovers -- as they learn the rules of the game.</p>"
      ))
  }

  override func setupConstraints() {
    scrollView.edgesToSuperview()
    mainHorizontalStackView.edgesToSuperview()
    mainHorizontalStackView.width(to: self)
  }

  override func additionalConfiguration() {
    backgroundColor = .systemBackground

    posterImageView.posterURL = URL(
      string: "https://static.tvmaze.com/uploads/images/original_untouched/2/5301.jpg")
    titleInfoView.title = "This is a very big show name, and it needs to be bigger"
    titleInfoView.genres = (0..<10).map { "Genre \($0)" }
  }

}

private final class PosterImageView: BaseView {
  private let imageView = with(UIImageView()) {
    $0.contentMode = .scaleToFill
    $0.kf.indicatorType = .activity
  }

  var posterURL: URL? {
    didSet {
      imageView.kf.setImage(with: posterURL)
    }
  }

  override func setupViewHierarchy() {

    addSubview(imageView)

  }

  override func setupConstraints() {
    imageView.edgesToSuperview()
    imageView.heightToWidth(of: self, multiplier: 1.47)
  }

  override func additionalConfiguration() {
    backgroundColor = .secondarySystemBackground
  }
}

private final class TitleInfoView: BaseView {
  private let titleLabel = with(UILabel()) {
    $0.font = .preferredFont(forTextStyle: .title2)
    $0.numberOfLines = 0
  }

  private let genresView = GenresView()

  var title: String? {
    didSet { titleLabel.text = title }
  }

  var genres: [String] = [] {
    didSet { genresView.genres = genres }
  }

  override func setupViewHierarchy() {
    addSubview(titleLabel)
    addSubview(genresView)
  }

  override func setupConstraints() {
    titleLabel.edgesToSuperview(excluding: .bottom, insets: .uniform(20))
    genresView.edgesToSuperview(excluding: .top, insets: .bottom(20))
    titleLabel.bottomToTop(of: genresView, offset: -8)
  }
}

private final class GenresView: BaseView {
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

private func separator() -> UIView {
  let view = UIView()
  view.backgroundColor = .secondarySystemBackground
  view.height(1)
  return view
}

private final class ScheduleView: BaseView {

  struct ViewModel {
    struct Schedule {
      let time: String
      let days: [String]
    }

    init(schedule: Schedule) {
      let allWeekDays = Calendar.current.standaloneWeekdaySymbols
      let shortWeekDays = Calendar.current.shortStandaloneWeekdaySymbols

      items = zip(allWeekDays, shortWeekDays).map { weekDay, shortWeekDay in
        Item(
          day: shortWeekDay,
          time: schedule.time,
          isHighlighted: schedule.days.contains(weekDay)
        )
      }
    }

    struct Item {
      let day: String
      let time: String
      let isHighlighted: Bool
    }

    let items: [Item]
  }

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

    viewModel.items
      .map(ScheduleView.makeView(for:))
      .forEach(stackView.addArrangedSubview(_:))
  }

  override func setupConstraints() {
    containerView.edgesToSuperview()
    scrollView.edgesToSuperview(insets: .vertical(20))
    stackView.edgesToSuperview()
    stackView.heightToSuperview()
  }

  private static func makeView(for item: ViewModel.Item) -> UIView {
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

private final class SummaryView: BaseView {

  private lazy var label = with(UILabel()) {
    $0.numberOfLines = 0
    $0.attributedText = summary.htmlAttributedString()
  }

  let summary: String

  init(summary: String) {
    self.summary = summary
    super.init()
  }

  override func setupViewHierarchy() {
    addSubview(label)
  }

  override func setupConstraints() {
    label.edgesToSuperview(insets: .uniform(20))
  }
}
