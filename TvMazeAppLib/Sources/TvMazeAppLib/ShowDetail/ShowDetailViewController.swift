import UIKit

final class ShowDetailViewController: UICollectionViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func loadView() {
    view = ShowDetailView()
  }
}

final class ShowDetailView: UIView {

  private let scrollView = UIScrollView()
  private let mainHorizontalStackView = with(UIStackView()) {
    $0.axis = .vertical
  }

  private let posterImageView = PosterImageView()
  private let titleInfoView = TitleInfoView()

  init() {
    super.init(frame: .zero)

    setupViewHierarchy()
    setupConstraints()
    additionalConfiguration()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViewHierarchy() {
    addSubview(scrollView)
    scrollView.addSubview(mainHorizontalStackView)

    mainHorizontalStackView.addArrangedSubview(posterImageView)
    mainHorizontalStackView.addArrangedSubview(titleInfoView)
  }

  private func setupConstraints() {
    scrollView.edgesToSuperview(usingSafeArea: true)
    mainHorizontalStackView.edgesToSuperview()
    mainHorizontalStackView.width(to: self)
  }

  private func additionalConfiguration() {
    backgroundColor = .systemBackground

    posterImageView.posterURL = URL(
      string: "https://static.tvmaze.com/uploads/images/original_untouched/2/5301.jpg")
    titleInfoView.title = "This is a very big show name, and it needs to be bigger"
    titleInfoView.genres = (0..<10).map { "Genre \($0)" }
  }

}

private final class PosterImageView: UIView {
  private let imageView = with(UIImageView()) {
    $0.contentMode = .scaleToFill
    $0.kf.indicatorType = .activity
  }

  var posterURL: URL? {
    didSet {
      imageView.kf.setImage(with: posterURL)
    }
  }

  init() {
    super.init(frame: .zero)

    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    backgroundColor = .secondarySystemBackground
    addSubview(imageView)
    imageView.edgesToSuperview()

    imageView.heightToWidth(of: self, multiplier: 1.47)
  }
}

private final class TitleInfoView: UIView {
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

  init() {
    super.init(frame: .zero)

    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    addSubview(titleLabel)
    addSubview(genresView)

    titleLabel.edgesToSuperview(excluding: .bottom, insets: .uniform(20))
    genresView.edgesToSuperview(excluding: .top, insets: .bottom(20))
    titleLabel.bottomToTop(of: genresView, offset: -8)
  }
}

private final class GenresView: UIView {
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

  init() {
    super.init(frame: .zero)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    addSubview(scrollView)
    scrollView.addSubview(stackView)
    scrollView.edgesToSuperview()
    stackView.edgesToSuperview()
    stackView.height(to: self)

    //        height(40)
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
