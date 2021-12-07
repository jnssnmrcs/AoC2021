func day7part1(_ input: String) {
    let positions = input.components(separatedBy: ",").map { Int($0)! }
    let highestPosition = positions.reduce(0) { $1 > $0 ? $1 : $0 }
    let lowestPosition = positions.reduce(0) { $1 < $0 ? $1 : $0 }
    var lowestCost: Int? = nil
    
    for position in lowestPosition...highestPosition {
        let cost = positions.reduce(0) { $0 + abs($1 - position) }
        
        if (lowestCost == nil || cost < lowestCost!) {
            lowestCost = cost
        }
    }
    
    print("Part 1 answer: \(lowestCost!)")
}

func day7part2(_ input: String) {
    let positions = input.components(separatedBy: ",").map { Int($0)! }
    let highestPosition = positions.reduce(0) { $1 > $0 ? $1 : $0 }
    let lowestPosition = positions.reduce(0) { $1 < $0 ? $1 : $0 }
    var lowestCost: Int? = nil
    var costCache: [Int:Int] = [:]
    
    for position in lowestPosition...highestPosition {
        let cost = positions.reduce(0) { (sum, current) -> Int in
            let moves = abs(current - position)
            
            if (moves == 0) {
                return sum
            }
            
            if (costCache[moves] == nil) {
                costCache[moves] = Array(1...moves).reduce(0) { $0 + $1 }
            }
            
            return sum + costCache[moves]!
        }
        
        if (lowestCost == nil || cost < lowestCost!) {
            lowestCost = cost
        }
    }
    
    print("Part 2 answer: \(lowestCost!)")
}

func day7() {
    let input = getInput("day7", "input.txt")
    
    day7part1(input)
    day7part2(input)
}
