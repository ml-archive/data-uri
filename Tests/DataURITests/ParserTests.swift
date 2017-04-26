import Core
import XCTest

@testable import DataURI

class ParserTests: XCTestCase {
    static var allTests = [
        ("testParserInit", testParserInit),
        ("testExtractType", testExtractType),
        ("testExtractTypeFailed", testExtractTypeFailed),
        ("testExtractTypeMetadata", testExtractTypeMetadata),
        ("testExtractTypeWithMetadata", testExtractTypeWithMetadata),
        ("testConsumeUntil", testConsumeUntil),
        ("testConsumeWhile", testConsumeWhile),
        ("testConsume", testConsume),
        ("testConsumePercentDecoded", testConsumePercentDecoded),
        ("testConsumePercentDecodedFailed", testConsumePercentDecodedFailed)
    ]
    
    func testParserInit() {
        let bytes: [Byte] = [ .D, .E, .A, .D, .B, .E, .E, .F ]
        var parser = DataURIParser(scanner: Scanner(bytes))
        
        //check if first bytes match
        XCTAssertNotNil(parser.scanner.peek())
        XCTAssertEqual(parser.scanner.pop(), .D)
        
        //pop everything but the last `F`
        parser.scanner.pop(bytes.count - 2)
        XCTAssertNotNil(parser.scanner.peek())
        
        //check the last bytes and pop
        XCTAssertEqual(parser.scanner.pop(), .F)
        
        //assert scanner is empty
        XCTAssertNil(parser.scanner.peek())
    }
    
    func testExtractType() {
        expectNoThrow(){
            let bytes = "text/html,DEADBEEF".bytes
            var parser = DataURIParser(scanner: Scanner(bytes))
            let (type, metadata) = try parser.extractType()
            
            XCTAssertEqual(type.makeString(), "text/html")
            XCTAssertNil(metadata)
        }
    }
    
    /**
     This test ensures the type is terminated by `,` or `;` and that there is
     data left to be parsed.
     */
    func testExtractTypeFailed() {
        let bytes = "text/html".bytes
        var parser = DataURIParser(scanner: Scanner(bytes))
        
        expect(toThrow: DataURIParser.Error.invalidURI) {
            try parser.extractType()
        }
    }
    
    func testExtractTypeMetadata() {
        expectNoThrow() {
            let bytes = ";base64,DEADBEEF".bytes
            var parser = DataURIParser(scanner: Scanner(bytes))
            let metadata = try parser.extractTypeMetadata()
            
            XCTAssertEqual(metadata.makeString(), "base64")
        }
    }
    
    func testExtractTypeWithMetadata() {
        expectNoThrow() {
            let bytes = "text/html;base64,DEADBEEF".bytes
            var parser = DataURIParser(scanner: Scanner(bytes))
            let (type, metadata) = try parser.extractType()
            
            XCTAssertEqual(type.makeString(), "text/html")
            XCTAssertNotNil(metadata)
            XCTAssertEqual(metadata?.makeString(), "base64")
        }
    }
    
    func testConsumeUntil() {
        let bytes: [Byte] = [
            .a,
            .A,
            .B,
            .comma,
            .f
        ]
        
        let expected: [Byte] = [.a, .A, .B]
        
        var parser = DataURIParser(scanner: Scanner(bytes))
        let output = parser.consume(until: [.comma])
        
        XCTAssertEqual(output, expected)
        XCTAssertNotNil(parser.scanner.peek())
        XCTAssertEqual(parser.scanner.pop(), Byte.comma)
    }
    
    func testConsumeWhile() {
        let bytes: [Byte] = [
            .a,
            .a,
            .a,
            .comma,
            .F
        ]
        
        let expected: [Byte] = [.a, .a, .a]
        
        var parser = DataURIParser(scanner: Scanner(bytes))
        let output = parser.consume(while: { $0 == .a })
        
        XCTAssertEqual(output, expected)
        XCTAssertNotNil(parser.scanner.peek())
        XCTAssertEqual(parser.scanner.pop(), Byte.comma)
    }
    
    func testConsume() {
        let bytes: [Byte] = [
            .a,
            .C,
            .semicolon,
            .comma,
            .f
        ]
        
        let expected: [Byte] = [.a, .C, .semicolon, .comma, .f]
        
        var parser = DataURIParser(scanner: Scanner(bytes))
        let output = parser.consume()
        
        XCTAssertEqual(output, expected)
        XCTAssertNil(parser.scanner.peek())
    }
    
    func testConsumePercentDecoded() {
        let bytes: [Byte] = [
            .a,
            .C,
            .semicolon,
            .comma,
            .percent,
            0x32, //2
            .C,
            .percent,
            0x32, // 2
            0x00,
            .f
        ]
        
        let expected: [Byte] = [.a, .C, .semicolon, .comma, .comma, .space, .f]
        
        var parser = DataURIParser(scanner: Scanner(bytes))
        let output = try! parser.consumePercentDecoded()
        
        XCTAssertEqual(output, expected)
        XCTAssertNil(parser.scanner.peek())
    }
    
    func testConsumePercentDecodedFailed() {
        let bytes: [Byte] = [
            .percent,
            .C,
        ]
    
        expect(toThrow: DataURIParser.Error.invalidURI) {
            var parser = DataURIParser(scanner: Scanner(bytes))
            _ = try parser.consumePercentDecoded()
        }
    }
}
