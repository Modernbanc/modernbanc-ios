import XCTest
@testable import modernbanc_ios

final class modernbanc_iosTests: XCTestCase {
    func testMain() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let client = ModernbancApiClient(api_key: "test_key")
        XCTAssertNotNil(client)
        
        let textfield = ModernbancTextfield(client: client)
        
        func isLongerThan5Characters(text:String?) -> Bool {
            return (text?.count ?? 0) > 5
        }
        
        textfield.validationFn = isLongerThan5Characters
        
        textfield.text = "Hello"
        
        XCTAssertNil(textfield.text)
        XCTAssertFalse(textfield.isValid!)
        
        textfield.text = "Hello world"
        XCTAssertTrue(textfield.isValid!)
    }
}
