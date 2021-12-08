import Foundation

extension Dictionary where Value: Equatable {
    func firstKey(of val: Value) -> Key? {
        return self.filter { $1 == val }.map { $0.key }.first
    }
}

extension String {
    func removeCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }

    func removeCharacters(from: String) -> String {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }
    
    func except(_ from: String) -> String {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }
    
    func paddingLeft(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
    
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
