import XCTest
@testable import TvMazeAppLib

final class TvMazeAppLibTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TvMazeAppLib().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
