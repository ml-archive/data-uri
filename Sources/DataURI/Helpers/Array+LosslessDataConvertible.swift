import Foundation
public protocol LosslessDataConvertible {
    /// Losslessly converts this type to `Data`.
    func convertToData() -> Data

    /// Losslessly converts `Data` to this type.
    static func convertFromData(_ data: Data) -> Self
}

extension Array: LosslessDataConvertible where Element == UInt8 {
    /// Converts this `[UInt8]` to `Data`.
    public func convertToData() -> Data {
        return Data(bytes: self)
    }

    /// Converts `Data` to `[UInt8]`.
    public static func convertFromData(_ data: Data) -> Array<UInt8> {
        return .init(data)
    }
}
