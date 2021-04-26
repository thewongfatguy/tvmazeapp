import Helpers
import Kingfisher
import UIKit

final class EpisodeCell: UITableViewCell {

  private let episodeImageView = with(UIImageView()) {
    $0.contentMode = .scaleAspectFill
    $0.backgroundColor = .secondarySystemBackground
    $0.kf.indicatorType = .activity
    $0.layer.cornerRadius = 4
    $0.layer.masksToBounds = true
  }

  private let nameLabel = with(UILabel()) {
    $0.font = .preferredFont(forTextStyle: .headline)
  }

  private let summaryLabel = with(UILabel()) {
    $0.font = .preferredFont(forTextStyle: .subheadline)
    $0.numberOfLines = 0
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    episodeImageView.kf.cancelDownloadTask()
  }

  func bind(to episode: EpisodesListViewModel.Output.EpisodeDisplay) {
    episodeImageView.kf.setImage(with: episode.imageURL)
    nameLabel.text = episode.name
    summaryLabel.text = episode.summary
  }

  private func setup() {
    let containerView = Stack.horizontal(
      alignment: .center,
      episodeImageView,
      Stack.vertical(
        alignment: .leading,
        spacing: 0,
        nameLabel, summaryLabel
      )
    ).rootView

    contentView.addSubview(containerView)

    containerView.edgesToSuperview(insets: .uniform(20))
    episodeImageView.width(to: contentView, multiplier: 0.4)
  }
}
