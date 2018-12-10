public typealias Byte = UInt8
public typealias Bytes = [Byte]

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
