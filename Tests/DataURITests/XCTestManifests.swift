import XCTest

extension DataURITests {
    static let __allTests = [
        ("testBase64Text", testBase64Text),
        ("testFailedInvalidScheme", testFailedInvalidScheme),
        ("testHTMLJavascriptText", testHTMLJavascriptText),
        ("testHTMLText", testHTMLText),
        ("testPublicInterface", testPublicInterface),
        ("testSpeed", testSpeed),
        ("testTextNoType", testTextNoType),
    ]
}

extension ParserTests {
    static let __allTests = [
        ("testConsume", testConsume),
        ("testConsumePercentDecoded", testConsumePercentDecoded),
        ("testConsumePercentDecodedFailed", testConsumePercentDecodedFailed),
        ("testConsumeUntil", testConsumeUntil),
        ("testConsumeWhile", testConsumeWhile),
        ("testExtractType", testExtractType),
        ("testExtractTypeFailed", testExtractTypeFailed),
        ("testExtractTypeMetadata", testExtractTypeMetadata),
        ("testExtractTypeWithMetadata", testExtractTypeWithMetadata),
        ("testParserInit", testParserInit),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DataURITests.__allTests),
        testCase(ParserTests.__allTests),
    ]
}
#endif
