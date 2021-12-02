
func day1part1(_ input: String) {
    let depths = input.components(separatedBy: "\n")
    var increases = 0

    for i in 1..<depths.count {
        guard let current = Int(depths[i]), let previous = Int(depths[i - 1]) else {
            continue
        }

        if (current > previous) {
            increases += 1
        }
    }

    print("part 1 answer: \(increases)")
}

func day1part2(_ input: String) {
    let depths = input.components(separatedBy: "\n")
    var increases = 0

    for i in 3..<depths.count {
        guard let fourth = Int(depths[i]), let third = Int(depths[i - 1]), let second = Int(depths[i - 2]), let first = Int(depths[i - 3]) else {
            continue
        }

        let previousWindowSum = first + second + third
        let currentWindowSum = second + third + fourth

        if (currentWindowSum > previousWindowSum) {
            increases += 1
        }
    }

    print("part 2 answer: \(increases)")
}

func day1() {
    let input = getInput("day1")
    
    day1part1(input)
    day1part2(input)
}
