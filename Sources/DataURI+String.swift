import Core
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
}
