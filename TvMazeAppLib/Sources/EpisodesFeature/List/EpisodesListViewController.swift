import Combine
import Helpers
import Models
import UIKit

final class EpisodesListViewController: UIViewController {

  public var didFinish: (() -> Void)?

  public var didTapShareEpisode: ((Episode) -> Void)!

  private let viewModel: EpisodesListViewModel
  private var cancellable: AnyCancellable?

  private lazy var rootView = with(EpisodesListView()) {
    $0.didTapShareEpisode = { [weak self] in self?.didTapShareEpisode($0.episode) }
  }

  init(viewModel: EpisodesListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = rootView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "All episodes"

    cancellable = viewModel.fetchEpisodes()
      .handleUIChanges(on: rootView, with: EpisodesListView.handleViewModelOutputs)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isBeingDismissed || isMovingFromParent {
      didFinish?()
      didFinish = nil
    }
  }
}
