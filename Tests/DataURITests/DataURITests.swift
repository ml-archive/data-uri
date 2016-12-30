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
    
    func testBase64() {
        //FIXME(Brett): remove when vapor/core is updated to 1.1
        let base64Bytes = "SGVsbG8sIHdvcmxkIQ==".bytes
        let output = base64Bytes.base64Decoded
        XCTAssertEqual(output.string, "Hello, world!")
    }
    
    func testTextNoType() {
        let (data, type, meta) = try! DataURIParser.parse(
            uri: "data:,Hello%2C%20World!"
        )
        
        XCTAssertEqual(data.string, "Hello, World!")
        XCTAssertEqual(type.string, "text/plain;charset=US-ASCII")
        XCTAssertNil(meta)
    }
    
    func testBase64Text() {
        let (data, type, meta) = try! DataURIParser.parse(
            uri: "data:text/plain;base64,SGVsbG8sIFdvcmxkIQ%3D%3D"
        )
        
        XCTAssertEqual(data.string, "Hello, World!")
        XCTAssertEqual(type.string, "text/plain")
        XCTAssertEqual(meta?.string, "base64")
    }
    
    func testHTMLText() {
        let (data, type, meta) = try! DataURIParser.parse(
            uri: "data:text/html,%3Ch1%3EHello%2C%20World!%3C%2Fh1%3E"
        )
        
        XCTAssertEqual(data.string, "<h1>Hello, World!</h1>")
        XCTAssertEqual(type.string, "text/html")
        XCTAssertNil(meta)
    }
    
    func testHTMLJavascriptText() {
        let (data, type, meta) = try! DataURIParser.parse(
            uri: "data:text/html,<script>alert('hi');</script>"
        )
        
        XCTAssertEqual(data.string, "<script>alert('hi');</script>")
        XCTAssertEqual(type.string, "text/html")
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
            XCTAssertEqual(data.string, "Hello, World!")
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
    
    //FIXME(Brett): remove when Core 1.1 includes `base64Decoded`
    // required for 100% coverage
    func testBase64DecodeFailure() {
        var bytes = "SGVsbG8sIFdvcmxkIQ%3D%3D".bytes //Hello World!
        bytes.append(0x1E) //invalid control character
        let decodedBytes = bytes.base64Decoded
        XCTAssertEqual(
            decodedBytes, [],
            "Invalid character should have caused the base64Decoder to escape."
        )
    }
}
