extension StringProtocol {
    subscript(offset: Int) -> String {
        String(self[index(startIndex, offsetBy: offset)])
    }
}

extension Array {
    mutating func shift() -> Element? {
        if (self.isEmpty) {
            return nil
        }
        
        let removed: Element? = self.first
        
        self = self.enumerated().filter { (index, element) -> Bool in
            return index != 0
        }.map { $0.element }
        
        return removed
    }
}

extension String {
    func paddingLeft(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}
