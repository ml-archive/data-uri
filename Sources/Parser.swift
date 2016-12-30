import Core

/// A parser for decoding Data URIs.
public struct DataURIParser {
    enum Error: Swift.Error {
        case invalidScheme
        case invalidURI
    }
    
    var scanner: Scanner<Byte>
    
    init(scanner: Scanner<Byte>) {
        self.scanner = scanner
    }
}

extension DataURIParser {
    /**
        Parses a Data URI and returns its type and data.
     
        - Parameters:
            - uri: The URI to be parsed.
     
        - Returns: (data: Bytes, type: Bytes, typeMetadata: Bytes?)
     */
    public static func parse(uri: String) throws -> (Bytes, Bytes, Bytes?) {
        guard uri.hasPrefix("data:") else {
            throw Error.invalidScheme
        }
        
        var scanner = Scanner(uri.bytes)
        //pop scheme ("data:")
        scanner.pop(5)
        
        var parser = DataURIParser(scanner: scanner)
        var (type, typeMetadata) = try parser.extractType()
        var data = try parser.extractData()
        
        //Required by RFC 2397
        if type.isEmpty {
            type = "text/plain;charset=US-ASCII".bytes
        }
        
        if let typeMetadata = typeMetadata, typeMetadata == "base64".bytes {
            data = data.base64Decoded
        }
        
        return (data, type, typeMetadata)
    }
}

extension DataURIParser {
    mutating func extractType() throws -> (Bytes, Bytes?) {
        let type = consume(until: [.comma, .semicolon])
        
        guard let byte = scanner.peek() else {
            throw Error.invalidURI
        }
        
        var typeMetadata: Bytes? = nil
        
        if byte == .semicolon {
            typeMetadata = try extractTypeMetadata()
        }
        
        return (type, typeMetadata)
    }
    
    mutating func extractTypeMetadata() throws -> Bytes {
        assert(scanner.peek() == .semicolon)
        scanner.pop()
        
        return consume(until: [.comma])
    }
    
    mutating func extractData() throws -> Bytes {
        assert(scanner.peek() == .comma)
        scanner.pop()
        return try consumePercentDecoded()
    }
}

extension DataURIParser {
    @discardableResult
    mutating func consume() -> Bytes {
        var bytes: Bytes = []
        
        while let byte = scanner.peek() {
            scanner.pop()
            bytes.append(byte)
        }
        
        return bytes
    }
    
    @discardableResult
    mutating func consumePercentDecoded() throws -> Bytes {
        var bytes: Bytes = []
        
        while var byte = scanner.peek() {
            if byte == .percent {
                byte = try decodePercentEncoding()
            }
            
            scanner.pop()
            bytes.append(byte)
        }
        
        return bytes
    }
    
    @discardableResult
    mutating func consume(until terminators: Set<Byte>) -> Bytes {
        var bytes: Bytes = []
        
        while let byte = scanner.peek(), !terminators.contains(byte) {
            scanner.pop()
            bytes.append(byte)
        }
        
        return bytes
    }
    
    @discardableResult
    mutating func consume(while conditional: (Byte) -> Bool) -> Bytes {
        var bytes: Bytes = []
        
        while let byte = scanner.peek(), conditional(byte) {
            scanner.pop()
            bytes.append(byte)
        }
        
        return bytes
    }
}

extension DataURIParser {
    mutating func decodePercentEncoding() throws -> Byte {
        assert(scanner.peek() == .percent)
        
        guard
            let leftMostDigit = scanner.peek(aheadBy: 1),
            let rightMostDigit = scanner.peek(aheadBy: 2)
        else {
            throw Error.invalidURI
        }
        
        scanner.pop(2)
        
        return (leftMostDigit.asciiCode * 16) + rightMostDigit.asciiCode
    }
}

extension Byte {
    internal var asciiCode: Byte {
        if self >= 48 && self <= 57 {
            return self - 48
        } else if self >= 65 && self <= 70 {
            return self - 55
        } else {
            return 0
        }
    }
}
