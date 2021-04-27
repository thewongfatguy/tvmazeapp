import Helpers
import XCTest

final class CoordinatorTests: XCTestCase {

  func test_Coordinator_ShouldNotMemLeak() {
    let coord1 = Coordinator()
    var coord2: Coordinator? = Coordinator()
    weak var coord3 = coord2

    coord1.coordinate(to: coord2!)
    coord2?.didFinish()
    coord2 = nil

    XCTAssertNil(coord3)
  }
}
