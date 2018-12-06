import Foundation

extension String {
    /**
        Parses a Data URI and returns its data and type.
     
        - Returns: The type of the file and its data as bytes.
     */
    public func dataURIDecoded() throws -> (data: Bytes, type: String) {
        let (data, type, _) = try DataURIParser.parse(uri: self)
        return (data, type.makeString())
    }

    /// Converts the string to a UTF8 array of bytes.
    public var bytes: [UInt8] {
        return [UInt8](self.utf8)
    }
}
