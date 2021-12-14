typealias InsertionRules = [String:Character]

func parseInput(_ input: String) -> (template: String, rules: InsertionRules) {
    let parts = input.components(separatedBy: "\n\n")
    let template = parts[0]
    var rules: InsertionRules = [:]
    let lines = parts[1].components(separatedBy: "\n")
    
    for line in lines {
        let ruleParts = line.components(separatedBy: " -> ")
        
        rules[ruleParts[0]] = Character(ruleParts[1])
    }
    
    return (template, rules)
}

func day14part1(_ input: String) {
    var (template, rules) = parseInput(input)
    var occurrences: [Character:Int] = [:]
    let steps = 10
    
    for character in template {
        occurrences[character] = occurrences[character] == nil ? 1 : occurrences[character]! + 1
    }

    for _ in 1...steps {
        var inserted = 0

        for i in 0..<template.count - 1 {
            let pair = String(template.prefix(i + inserted + 2).suffix(2))
            let offset = i + inserted + 1
            let index = template.index(template.startIndex, offsetBy: offset)
            
            guard let insertion = rules[pair] else {
                continue
            }
            
            template.insert(insertion, at: index)
            inserted += 1
            occurrences[insertion] = occurrences[insertion] != nil ? occurrences[insertion]! + 1 : 1
        }
    }
    
    let sorted = occurrences.sorted { $0.value > $1.value }
    let answer = sorted.first!.value - sorted.last!.value
    
    print("Part 1 answer: \(answer)")
}

func day14part2(_ input: String) {
    let (template, rules) = parseInput(input)
    let steps = 40
    var pairs: [String:Int] = [:]
    
    // Add initial pairs
    for i in 0..<template.count - 1 {
        let pair = String(template.prefix(i + 2).suffix(2))
        
        pairs[pair] = (pairs[pair] ?? 0) + 1
    }
    
    // Run rules for set amount of steps
    for _ in 1...steps {
        let oldPairs = pairs
        
        for rule in rules {
            let (match, insertion) = rule
            
            if (oldPairs[match] == nil) {
                continue
            }
            
            // Convert matching pair into new pairs according to rule
            let leftPair = String([match.first!, insertion])
            let rightPair = String([insertion, match.last!])
            let oldCount = oldPairs[match]!
            
            pairs[leftPair] = (pairs[leftPair] ?? 0) + oldCount
            pairs[rightPair] = (pairs[rightPair] ?? 0) + oldCount
            pairs[match] = pairs[match]! - oldCount
            
            // If the matching pair no longer exists we have to remove it
            if (pairs[match]! <= 0) {
                pairs.removeValue(forKey: match)
            }
        }
    }

    // Count occurrences of each character
    var occurrences: [Character:Int] = [:]
    
    // Add first and last character in template since every character but these are counted twice
    occurrences[template.first!] = 1
    occurrences[template.last!] = 1
    
    // Count both characters in each pair, which will cause every character except first and last in template to be counted twice
    for (pair, count) in pairs {
        occurrences[pair.first!] = (occurrences[pair.first!] ?? 0) + count
        occurrences[pair.last!] = (occurrences[pair.last!] ?? 0) + count
    }
    
    // Sort to easily find most and least common characters
    let sorted = occurrences.sorted { $0.value > $1.value }
    
    // Divide answer by 2 since every character is counted twice
    let answer = (sorted.first!.value - sorted.last!.value) / 2
    
    print("Part 2 answer: \(answer)")
}

func day14() {
    let input = getInput("day14", "input.txt")
    
    day14part1(input)
    day14part2(input)
}
