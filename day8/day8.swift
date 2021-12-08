typealias Entry = (input:  [String], output: [String])
typealias Configuration = [String:String]

let numberPositions = [
    "012345",  // 0
    "12",      // 1
    "01346",   // 2
    "01236",   // 3
    "1256",    // 4
    "02356",   // 5
    "023456",  // 6
    "012",     // 7
    "0123456", // 8
    "012356",  // 9
]

func parseEntries(_ rawEntries: [String]) -> [Entry] {
    let entries = rawEntries.map { (line) -> Entry in
        let parts = line.components(separatedBy: " | ")
        let input = parts[0].components(separatedBy: " ")
        let output = parts[1].components(separatedBy: " ")
        
        return (input, output)
    }
    
    return entries
}

func getValue(ofLetters letters: String, withConfiguration configuration: Configuration) -> String {
    let positionNumbers = String(letters.map { Character(configuration.firstKey(of: String($0))!) }.sorted())
    
    return String(numberPositions.firstIndex(of: positionNumbers)!)
}

func getConfiguration(forSignals signals: [String]) -> Configuration {
    var configuration: Configuration = [:]
    
    let one = signals.first { $0.count == 2 }!
    let four = signals.first { $0.count == 4 }!
    let seven = signals.first { $0.count == 3 }!
    let eight = signals.first { $0.count == 7 }!
    
    configuration["0"] = seven.except(one)
    configuration["1"] = one
    configuration["2"] = one
    configuration["3"] = eight.except(one + four + seven)
    configuration["4"] = eight.except(one + four + seven)
    configuration["5"] = four.except(one)
    configuration["6"] = four.except(one)
    
    let sixLetterSignals = signals.filter { $0.count == 6 }
    
    for signal in sixLetterSignals {
        var remove = numberPositions[0].reduce("") { $1 == "5" ? $0 : $0 + configuration[String($1)]! }
        var remaining = signal.except(remove)
        
        if (remaining.count == 1) {
            configuration["5"] = remaining
            configuration["6"] = configuration["6"]!.except(remaining)
            continue
        }
        
        remove = numberPositions[6].reduce("") { $1 == "2" ? $0 : $0 + configuration[String($1)]! }
        remaining = signal.except(remove)
        
        if (remaining.count == 1) {
            configuration["2"] = remaining
            configuration["1"] = configuration["1"]!.except(remaining)
            continue
        }
        
        remove = numberPositions[9].reduce("") { $1 == "3" ? $0 : $0 + configuration[String($1)]! }
        remaining = signal.except(remove)
        
        if (remaining.count == 1) {
            configuration["3"] = remaining
            configuration["4"] = configuration["4"]!.except(remaining)
            continue
        }
    }
    
    return configuration
}

func day8part1(_ input: String) {
    let lines = input.components(separatedBy: "\n")
    let entries = parseEntries(lines)
    let uniqueLengths = [2,3,4,7]
    let total = entries.reduce(0) { (sum, signal) -> Int in
        return sum + signal.output.filter { uniqueLengths.contains($0.count) }.count
    }
    
    print("Part 1 answer: \(total)")
}

func day8part2(_ input: String) {
    let lines = input.components(separatedBy: "\n")
    let entries = parseEntries(lines)
    
    let total = entries.reduce(0) { (sum, entry) -> Int in
        let configuration = getConfiguration(forSignals: entry.input)
        let outputValue = entry.output.reduce("") { $0 + getValue(ofLetters: $1, withConfiguration: configuration) }

        return sum + Int(outputValue)!
    }
    
    print("Part 2 answer: \(total)")
}

func day8() {
    let input = getInput("day8", "input.txt")
    
    day8part1(input)
    day8part2(input)
}
