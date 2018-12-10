extension Sequence where Iterator.Element == Byte {
    /// Converts a slice of bytes to
    /// string. Courtesy of Vapor 2 - Core and @vzsg
    public func makeString() -> String {
        let array = Array(self) + [0]

        return array.withUnsafeBytes { rawBuffer in
            guard let pointer = rawBuffer.baseAddress?.assumingMemoryBound(to: CChar.self) else { return nil }
            return String(validatingUTF8: pointer)
            } ?? ""
    }
}
