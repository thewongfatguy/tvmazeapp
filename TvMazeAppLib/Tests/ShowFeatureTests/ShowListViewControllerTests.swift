import Combine
import Models
import XCTest

@testable import ApiClient
@testable import TvMazeAppLib

final class ShowListViewControllerTests: XCTestCase {
  func test_TappingShow_ShouldNavigateToShowDetail() {
    //        Env = .failing
    //
    //        let show = Show.stub()
    //
    //        let viewModel = ShowListViewModel()
    //
    //        Env.apiClient.shows = { page in
    //            Just(FetchShowsResult(page: page, result: [show]))
    //                .setFailureType(to: Error.self)
    //                .eraseToAnyPublisher()
    //        }
    //
    //        let viewController = ShowsListViewController()
    //        _ = viewController.view
    //
    //        let expectation = self.expectation(description: "wait for cell tap")
    //
    //        viewController.didSelectShow = { receivedShow in
    //            XCTAssertEqual(receivedShow, show)
    //            expectation.fulfill()
    //        }
    //
    //        viewController.collectionView(viewController.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
    //
    //        waitForExpectations(timeout: 10.0)
  }
}
