import XCTest
import Core

@testable import DataURI

class DataURITests: XCTestCase {
    static var allTests = [
        ("testTextNoType", testTextNoType),
        ("testBase64Text", testBase64Text),
        ("testHTMLText", testHTMLText),
        ("testHTMLJavascriptText", testHTMLJavascriptText),
        ("testFailedInvalidScheme", testFailedInvalidScheme),
        ("testPublicInterface", testPublicInterface),
        ("testSpeed", testSpeed)
    ]
    
    func testTextNoType() {
        let (data, type, meta) = try! DataURIParser.parse(
            uri: "data:,Hello%2C%20World!"
        )
        
        XCTAssertEqual(data.makeString(), "Hello, World!")
        XCTAssertEqual(type.makeString(), "text/plain;charset=US-ASCII")
        XCTAssertNil(meta)
    }
    
    func testBase64Text() {
        let (data, type, meta) = try! DataURIParser.parse(
            uri: "data:text/plain;base64,SGVsbG8sIFdvcmxkIQ%3D%3D"
        )
        
        XCTAssertEqual(data.makeString(), "Hello, World!")
        XCTAssertEqual(type.makeString(), "text/plain")
        XCTAssertEqual(meta?.makeString(), "base64")
    }
    
    func testHTMLText() {
        let (data, type, meta) = try! DataURIParser.parse(
            uri: "data:text/html,%3Ch1%3EHello%2C%20World!%3C%2Fh1%3E"
        )
        
        XCTAssertEqual(data.makeString(), "<h1>Hello, World!</h1>")
        XCTAssertEqual(type.makeString(), "text/html")
        XCTAssertNil(meta)
    }
    
    func testHTMLJavascriptText() {
        let (data, type, meta) = try! DataURIParser.parse(
            uri: "data:text/html,<script>alert('hi');</script>"
        )
        
        XCTAssertEqual(data.makeString(), "<script>alert('hi');</script>")
        XCTAssertEqual(type.makeString(), "text/html")
        XCTAssertNil(meta)
    }
    
    func testFailedInvalidScheme() {
        expect(toThrow: DataURIParser.Error.invalidScheme) {
            try DataURIParser.parse(uri: "date:")
        }
    }
    
    func testPublicInterface() {
        expectNoThrow() {
            let (data, type) = try "data:,Hello%2C%20World!".dataURIDecoded()
            XCTAssertEqual(data.makeString(), "Hello, World!")
            XCTAssertEqual(type, "text/plain;charset=US-ASCII")
        }
    }
    
    func testSpeed() {
        measure {
            for _ in 0..<10_000 {
                _ = try! DataURIParser.parse(
                    uri: "data:,Hello%2C%20World!"
                )
            }
        }
    }
}
