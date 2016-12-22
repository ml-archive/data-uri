import Core

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
    public static func parse(uri: String) throws -> (Bytes, Bytes?, Bytes) {
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
        
        if type == "base64".bytes {
            data = data.base64Decoded
        }
        
        return (type, typeMetadata, data)
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
        return consume()
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

