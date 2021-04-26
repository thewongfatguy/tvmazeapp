import Combine
import UIKit

final class EpisodesListViewController: UIViewController {

  private let viewModel: EpisodesListViewModel
  private var cancellable: AnyCancellable?

  private let rootView = EpisodesListView()

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
}
