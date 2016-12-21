import XCTest
@testable import DataURI

class DataURITests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(DataURI().text, "Hello, World!")
    }


    static var allTests : [(String, (DataURITests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
