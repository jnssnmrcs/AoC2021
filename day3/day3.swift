func getBitSum(_ lines: [String], _ position: Int) -> Int {
    let bitSum = lines.reduce(0) { (sum, line) -> Int in
        let value = line[position] == "1" ? 1 : -1
        return sum + value
    }
    
    return bitSum
}

func getBitSums(_ lines: [String]) -> [Int]? {
    guard let size = lines.first?.count else {
        return nil
    }
    
    var bitSums = Array(repeating: 0, count: size)
    
    for line in lines {
        for (index, character) in line.enumerated() {
            let value = character == "1" ? 1 : -1
            bitSums[index] += value
        }
    }
    
    return bitSums
}

func day3part1(_ input: String) {
    let lines = input.components(separatedBy: "\n")
    
    guard let bitSums = getBitSums(lines) else {
        print("Invalid input")
        return
    }
    
    let gammaValue = bitSums.reduce("") { (result, value) -> String in
        let converted = value > 0 ? "1" : "0"
        return result + converted
    }
    let epsilonValue = gammaValue.reduce("") { (result, character) -> String in
        let inverted = character == "0" ? "1" : "0"
        return result + inverted
    }
    
    guard let gammaRate = Int(gammaValue, radix: 2), let epsilonRate = Int(epsilonValue, radix: 2) else {
        print("Failed to calculate power consumption")
        return
    }
    
    print("Part 1 answer: \(gammaRate * epsilonRate)")
}

func day3part2(_ input: String) {
    let lines = input.components(separatedBy: "\n")
    
    guard let size = lines.first?.count else {
        print("Invalid input")
        return
    }
    
    var oxygenValues = lines
    var scrubberValues = lines
    
    for currentBit in 0..<size {
        if (oxygenValues.count > 1) {
            let bitSum = getBitSum(oxygenValues, currentBit)
            let mostCommonBit = bitSum < 0 ? "0" : "1"
            
            oxygenValues = oxygenValues.filter { (line) -> Bool in
                return line[currentBit] == mostCommonBit
            }
        }
        
        if (scrubberValues.count > 1) {
            let bitSum = getBitSum(scrubberValues, currentBit)
            let leastCommonBit = bitSum < 0 ? "1" : "0"
            
            scrubberValues = scrubberValues.filter { (line) -> Bool in
                return line[currentBit] == leastCommonBit
            }
        }
    }
    
    guard let oxygenValue = oxygenValues.first, let scrubberValue = scrubberValues.first, let oxygenRating = Int(oxygenValue, radix: 2), let scrubberRating = Int(scrubberValue, radix: 2) else {
        print("Failed to calculate life support rating")
        return
    }
    
    print("Part 2 answer: \(oxygenRating * scrubberRating)")
}

func day3() {
    let input = getInput("day3", "input.txt")
    
    day3part1(input)
    day3part2(input)
}
