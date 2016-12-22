import Core
import Foundation

//FIXME(Brett): I patched this into Core 1.1, remove when updated.
extension Sequence where Iterator.Element == Byte {
    internal var base64Decoded: Bytes {
        let bytes = [Byte](self)
        let dataBase64 = Data(bytes: bytes)
        guard let data = Data(base64Encoded: dataBase64) else {
            return []
        }
        
        var encodedBytes = Bytes(repeating: 0, count: data.count)
        data.copyBytes(to: &encodedBytes, count: data.count)
        
        return encodedBytes
    }
}

extension String {
    /**
        Parses a Data URI and returns its type and data.
     
        - Returns: The type of the file and its data as bytes.
     */
    public func dataURIDecoded() throws -> (type: String, data: Bytes) {
        let (type, _, data) = try DataURIParser.parse(uri: self)
        return (type.string, data)
    }
}
