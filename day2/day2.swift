enum Direction: String {
    case up = "up"
    case down = "down"
    case forward = "forward"
}

typealias Instruction = (direction: Direction, value: Int)

func parseInstruction(_ raw: String) -> Instruction? {
    let parts = raw.components(separatedBy: " ")
    
    guard let direction = Direction(rawValue: parts[0]), let value = Int(parts[1]) else {
        return nil
    }
    
    return (direction, value)
}

func day2part1(_ input: String) {
    let instructions = input.components(separatedBy: "\n")
    var depth = 0
    var position = 0
    
    for rawInstruction in instructions {
        guard let instruction = parseInstruction(rawInstruction) else {
            continue
        }
        
        let (direction, value) = instruction
        
        switch direction {
        case .forward:
            position += value
        case .down:
            depth += value
        case .up:
            depth -= value
        }
    }
    
    print("Part 1 answer: \(depth * position)")
}

func day2part2(_ input: String) {
    let instructions = input.components(separatedBy: "\n")
    var aim = 0
    var depth = 0
    var position = 0
    
    for rawInstruction in instructions {
        guard let instruction = parseInstruction(rawInstruction) else {
            continue
        }
        
        let (direction, value) = instruction
        
        switch direction {
        case .forward:
            position += value
            depth += aim * value
        case .down:
            aim += value
        case .up:
            aim -= value
        }
    }
    
    print("Part 2 answer: \(depth * position)")
}

func day2() {
    let input = getInput("day2", "input.txt")
    
    day2part1(input)
    day2part2(input)
}
