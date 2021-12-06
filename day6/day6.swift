func day6part1(_ input: String) {
    var fishes = input.components(separatedBy: ",").map { Int($0)! }
    
    for _ in 0..<80 {
        for i in 0..<fishes.count {
            if (fishes[i] == 0) {
                fishes[i] = 6
                fishes.append(8)
            } else {
                fishes[i] -= 1
            }
        }
    }
    
    print("Part 1 answer: \(fishes.count)")
}

func day6part2(_ input: String) {
    let timers = input.components(separatedBy: ",").map { Int($0)! }
    var fishes = Array.init(repeating: 0, count: 9)
    
    for timer in timers {
        fishes[timer] += 1
    }
    
    for _ in 0..<256 {
        let reproducingFishes = fishes[0]
        fishes[0] = 0
        
        for i in 1..<9 {
            fishes[i - 1] = fishes[i]
        }
        
        // Reset timer for fishes reproducing
        fishes[6] += reproducingFishes
        
        // Spawn one new fish for each fish reproducing
        fishes[8] = reproducingFishes
    }
    
    let total = fishes.reduce(0) { $0 + $1 }
    
    print("Part 2 answer: \(total)")
}

func day6() {
    let input = getInput("day6", "input.txt")
    
    day6part1(input)
    day6part2(input)
}
