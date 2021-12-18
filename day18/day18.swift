import Foundation

fileprivate protocol SnailfishNumber: AnyObject {
    var parent: SnailfishPair? { get set }
    func toString() -> String
    func magnitude() -> Int
    func copy() -> SnailfishNumber
}

fileprivate class SnailfishRegular: SnailfishNumber {
    var value: Int
    var parent: SnailfishPair?
    
    init(value: Int, parent: SnailfishPair?) {
        self.value = value
        self.parent = parent
    }
    
    func copy() -> SnailfishNumber {
        return SnailfishRegular(value: value, parent: nil)
    }
    
    func split() {
        let left = SnailfishRegular(value: Int(floor(Double(value) / 2)), parent: nil)
        let right = SnailfishRegular(value: Int(ceil(Double(value) / 2)), parent: nil)
        let pair = SnailfishPair(left: left, right: right, parent: parent)
        
        // replace self
        if (parent != nil) {
            if (parent!.left === self) {
                parent!.left = pair
            } else {
                parent!.right = pair
            }
        }
    }
    
    func magnitude() -> Int {
        return value
    }
    
    func toString() -> String {
        return String(value)
    }
}

fileprivate class SnailfishPair: SnailfishNumber {
    var left: SnailfishNumber
    var right: SnailfishNumber
    var parent: SnailfishPair?
    
    init(left: SnailfishNumber, right: SnailfishNumber, parent: SnailfishPair?) {
        self.left = left
        self.right = right
        self.parent = parent
        self.left.parent = self
        self.right.parent = self
    }
    
    func copy() -> SnailfishNumber {
        let leftCopy = left.copy()
        let rightCopy = right.copy()
        
        return SnailfishPair(left: leftCopy, right: rightCopy, parent: nil)
    }
    
    func magnitude() -> Int {
        return 3 * left.magnitude() + 2 * right.magnitude()
    }
    
    func toString() -> String {
        return "[\(left.toString()),\(right.toString())]"
    }
    
    func explode() {
        // LEFT VALUE
        var current: SnailfishNumber? = parent
        var previous: SnailfishNumber? = self
        
        // Search upwards until current is no longer the left instance
        while let pair = current as? SnailfishPair  {
            if (pair.left !== previous) {
                previous = current
                current = pair.left
                break
            }
            
            previous = current
            current = pair.parent
        }
        
        // Move down keeping right in the found pair until we find a regular number
        while let pair = current as? SnailfishPair  {
            previous = current
            current = pair.right
        }
        
        // If we found a regular number, update it
        if let regular = current as? SnailfishRegular {
            regular.value += (self.left as! SnailfishRegular).value
        }
        
        // RIGHT VALUE
        current = parent
        previous = self
        
        // Search upwards until current is no longer the right instance
        while let pair = current as? SnailfishPair  {
            if (pair.right !== previous) {
                previous = current
                current = pair.right
                break
            }
            
            previous = current
            current = pair.parent
        }
        
        // Move down keeping left in the found pair until we find a regular number
        while let pair = current as? SnailfishPair  {
            previous = current
            current = pair.left
        }
        
        // If we found a regular number, update it
        if let regular = current as? SnailfishRegular {
            regular.value += (self.right as! SnailfishRegular).value
        }
        
        // replace self
        if (parent != nil) {
            if (parent!.left === self) {
                parent!.left = SnailfishRegular(value: 0, parent: parent)
            } else {
                parent!.right = SnailfishRegular(value: 0, parent: parent)
            }
        }
    }
}

fileprivate func parseSnailfishNumber(raw: String) -> SnailfishNumber {
    let integerRegex = try! NSRegularExpression(pattern: "^\\d+$")
    
    if (integerRegex.test(raw)) {
        return SnailfishRegular(value: Int(raw)!, parent: nil)
    }
    
    var opened = 0
    var left: SnailfishNumber? = nil
    var right: SnailfishNumber? = nil
    
    for (offset, character) in raw.enumerated() {
        let index = raw.index(raw.startIndex, offsetBy: offset)
        
        if (character == "[") {
            opened += 1
        } else if (character == "]") {
            opened -= 1
        } else if (character == "," && opened == 1) {
            // Left
            let leftStartIndex = raw.index(after: raw.startIndex)
            let leftRaw = String(raw[leftStartIndex..<index])
            
            left = parseSnailfishNumber(raw: leftRaw)
            
            // Right
            let rightStartIndex = raw.index(after: index)
            let rightEndIndex = raw.index(before: raw.endIndex)
            let rightRaw = String(raw[rightStartIndex..<rightEndIndex])
            
            right = parseSnailfishNumber(raw: rightRaw)
        }
    }
    
    return SnailfishPair(left: left!, right: right!, parent: nil)
}

fileprivate func parseSnailfishNumbers(_ input: String) -> [SnailfishNumber] {
    let numbers = input.components(separatedBy: "\n")
    var snailfishNumbers: [SnailfishNumber] = []
    
    for number in numbers {
        snailfishNumbers.append(parseSnailfishNumber(raw: number))
    }
    
    return snailfishNumbers
}

fileprivate func explodeLeftMost(number: SnailfishNumber, depth: Int = 0) -> Bool {
    if (number as? SnailfishRegular != nil) {
        return false
    }
    
    let pair = number as! SnailfishPair
    
    if (depth == 4) {
        pair.explode()
        return true
    }
    
    if (explodeLeftMost(number: pair.left, depth: depth + 1)) {
        return true
    }
    
    return explodeLeftMost(number: pair.right, depth: depth + 1)
}

fileprivate func splitLeftMost(number: SnailfishNumber) -> Bool {
    if let regular = number as? SnailfishRegular {
        if (regular.value >= 10) {
            regular.split()
            return true
        }
        
        return false
    }
    
    let pair = number as! SnailfishPair
    
    if (splitLeftMost(number: pair.left)) {
        return true
    }
    
    return splitLeftMost(number: pair.right)
}

fileprivate func add(lhs: SnailfishNumber, rhs: SnailfishNumber) -> SnailfishPair {
    let result = SnailfishPair(left: lhs, right: rhs, parent: nil)
    
    while true {
        let exploded = explodeLeftMost(number: result)
        
        if (!exploded) {
            let split = splitLeftMost(number: result)
            
            if (!split) {
                break
            }
        }
    }
    
    return result
}

fileprivate func day18part1(_ input: String) -> Int {
    var numbers = parseSnailfishNumbers(input)
    let initial = numbers.shift()!
    let sum = numbers.reduce(initial) { add(lhs: $0, rhs: $1) }
    
    return sum.magnitude()
}

fileprivate func day18part2(_ input: String) -> Int {
    let numbers = parseSnailfishNumbers(input)
    var highest = Int.min
    
    for first in numbers {
        for second in numbers {
            if (first === second) {
                continue
            }
            
            let lhs = first.copy()
            let rhs = second.copy()
            let result = add(lhs: lhs, rhs: rhs)
            let magnitude = result.magnitude()
            
            if (magnitude > highest) {
                highest = magnitude
            }
        }
    }
    
    return highest
}

func day18() {
    let input = getInput("day18", "input.txt")

    evaluateProblem(part: 1, day: "18") { day18part1(input) }
    evaluateProblem(part: 2, day: "18") { day18part2(input) }
}
