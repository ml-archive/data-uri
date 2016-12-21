import XCTest
@testable import DataURI

class DataURITests: XCTestCase {
    static var allTests = [
        ("testTextNoType", testTextNoType),
        ("testBase64Text", testBase64Text),
        ("testHTMLText", testHTMLText),
        ("testHTMLJavascriptText", testHTMLJavascriptText),
        ("testFailedInvalidScheme", testFailedInvalidScheme),
        ("testSpeed", testSpeed)
    ]
    
    func testTextNoType() {
        let (type, meta, data) = try! DataURIParser.parse(
            uri: "data:,Hello%2C%20World!"
        )
        
        XCTAssertEqual(type.string, "text/plain;charset=US-ASCII")
        XCTAssertNil(meta)
        XCTAssertEqual(data.string, "Hello%2C%20World!")
    }
    
    func testBase64Text() {
        let (type, meta, data) = try! DataURIParser.parse(
            uri: "data:text/plain;base64,SGVsbG8sIFdvcmxkIQ%3D%3D"
        )
        
        XCTAssertEqual(type.string, "text/plain")
        XCTAssertEqual(meta?.string, "base64")
        XCTAssertEqual(data.string, "SGVsbG8sIFdvcmxkIQ%3D%3D")
    }
    
    func testHTMLText() {
        let (type, meta, data) = try! DataURIParser.parse(
            uri: "data:text/html,%3Ch1%3EHello%2C%20World!%3C%2Fh1%3E"
        )
        
        XCTAssertEqual(type.string, "text/html")
        XCTAssertNil(meta)
        XCTAssertEqual(data.string, "%3Ch1%3EHello%2C%20World!%3C%2Fh1%3E")
    }
    
    func testHTMLJavascriptText() {
        let (type, meta, data) = try! DataURIParser.parse(
            uri: "data:text/html,<script>alert('hi');</script>"
        )
        
        XCTAssertEqual(type.string, "text/html")
        XCTAssertNil(meta)
        XCTAssertEqual(data.string, "<script>alert('hi');</script>")
    }
    
    func testFailedInvalidScheme() {
        expect(toThrow: DataURIParser.Error.invalidScheme) {
            try DataURIParser.parse(uri: "date:")
        }
    }
    
    func testSpeed() {
        measure {
            for _ in 0..<10_000 {
                let (_ , _, _) = try! DataURIParser.parse(
                    uri: "data:,Hello%2C%20World!"
                )
            }
        }
    }
}
