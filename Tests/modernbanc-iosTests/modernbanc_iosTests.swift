import XCTest
@testable import modernbanc_ios

final class modernbanc_iosTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let client = ModernbancApiClient(api_key: "test_key")
        XCTAssertNotNil(client)
    }
}
