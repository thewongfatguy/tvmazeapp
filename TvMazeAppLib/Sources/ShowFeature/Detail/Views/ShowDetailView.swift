import Helpers
import L10n
import UIKit

final class ShowDetailView: BaseView {

  private let showAllEpisodesAction: () -> Void

  private let scrollView = with(UIScrollView()) {
    $0.contentInsetAdjustmentBehavior = .always
  }

  private let mainHorizontalStackView = with(UIStackView()) {
    $0.axis = .vertical
  }

  init(showAllEpisodesAction: @escaping () -> Void) {
    self.showAllEpisodesAction = showAllEpisodesAction
    super.init()
  }

  override func setupViewHierarchy() {
    addSubview(scrollView)
    scrollView.addSubview(mainHorizontalStackView)
  }

  override func setupConstraints() {
    scrollView.edgesToSuperview()
    mainHorizontalStackView.edgesToSuperview()
    mainHorizontalStackView.width(to: self)
  }

  override func additionalConfiguration() {
    backgroundColor = .systemBackground
  }

  func render(_ showDetail: ShowDetailViewModel.ShowDetail) {
    if let posterURL = showDetail.posterURL {
      mainHorizontalStackView.addArrangedSubview(PosterImageView(posterURL: posterURL))
      mainHorizontalStackView.addArrangedSubview(SeparatorView())
    }

    mainHorizontalStackView.addArrangedSubview(
      TitleInfoView(name: showDetail.name, genres: showDetail.genres))
    mainHorizontalStackView.addArrangedSubview(SeparatorView())

    if let scheduleItems = showDetail.scheduleItems {
      mainHorizontalStackView.addArrangedSubview(ScheduleView(viewModel: scheduleItems))
      mainHorizontalStackView.addArrangedSubview(SeparatorView())
    }

    if let summary = showDetail.summary {
      mainHorizontalStackView.addArrangedSubview(SummaryView(summary: summary))
      mainHorizontalStackView.addArrangedSubview(SeparatorView())
    }

    mainHorizontalStackView.addArrangedSubview(
      with(UIButton(type: .system)) {
        $0.setTitle(L10n.GameFeature.Detail.seelAllEpisodes, for: .normal)
        $0.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        $0.contentEdgeInsets = .uniform(20)
        $0.addTarget(self, action: #selector(showAllEpisodesTapped), for: .touchUpInside)
      }
    )
    mainHorizontalStackView.addArrangedSubview(SeparatorView())
  }

  @objc
  private func showAllEpisodesTapped() {
    showAllEpisodesAction()
  }

}
