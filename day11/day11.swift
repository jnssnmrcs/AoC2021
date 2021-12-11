typealias Octopuses = Grid<Int>

func parseOctopuses(_ input: String) -> Octopuses {
    let lines = input.components(separatedBy: "\n")
    var octopuses = Grid(columns: 10, rows: 10, defaultValue: 0)
    
    for x in 0..<10 {
        for y in 0..<10 {
            octopuses[x, y] = Int(lines[y][x])!
        }
    }
    
    return octopuses
}

func getPoints(aroundPoint point: (x: Int, y: Int)) -> [(x: Int, y: Int)] {
    return [
        (point.x, point.y - 1),
        (point.x, point.y + 1),
        (point.x - 1, point.y),
        (point.x + 1, point.y),
        (point.x - 1, point.y - 1),
        (point.x + 1, point.y + 1),
        (point.x - 1, point.y + 1),
        (point.x + 1, point.y - 1),
    ]
}

@discardableResult func flash(_ octopuses: inout Octopuses, _ point: (x: Int, y: Int)) -> Int {
    let pointsAround = getPoints(aroundPoint: point).filter {
        octopuses.indexIsValid(column: $0.x, row: $0.y) && octopuses[$0.x, $0.y] != -1
    }
    var flashes = 1
    
    // Mark this octopus to not flash it twice
    octopuses[point.x, point.y] = -1
    
    // Increase energy in surrounding octopuses
    for pointAround in pointsAround {
        octopuses[pointAround.x, pointAround.y] = octopuses[pointAround.x, pointAround.y] + 1
    }
    
    // Flash surrounding octopuses
    for pointAround in pointsAround {
        if (octopuses[pointAround.x, pointAround.y] > 9) {
            flashes += flash(&octopuses, pointAround)
        }
    }
    
    return flashes
}

func day11part1(_ input: String) {
    var octopuses = parseOctopuses(input)
    var flashes = 0
    
    for _ in 0..<100 {
        // Increase energy
        for y in 0..<10 {
            for x in 0..<10 {
                octopuses[x, y] = octopuses[x, y] + 1
            }
        }
        
        // Flash
        for y in 0..<10 {
            for x in 0..<10 {
                if (octopuses[x, y] > 9) {
                    flashes += flash(&octopuses, (x, y))
                }
            }
        }
        
        // Reset energy
        for y in 0..<10 {
            for x in 0..<10 {
                if (octopuses[x, y] == -1) {
                    octopuses[x, y] = 0
                }
            }
        }
    }
    
    print("Part 1 answer: \(flashes)")
}

func day11part2(_ input: String) {
    var octopuses = parseOctopuses(input)
    var step = 1
    
    while true {
        // Increase energy
        for y in 0..<10 {
            for x in 0..<10 {
                octopuses[x, y] = octopuses[x, y] + 1
            }
        }
        
        // Flash
        for y in 0..<10 {
            for x in 0..<10 {
                if (octopuses[x, y] > 9) {
                    flash(&octopuses, (x, y))
                }
            }
        }
        
        // Reset energy
        var allFlashed = true
        for y in 0..<10 {
            for x in 0..<10 {
                let flashed = octopuses[x, y] == -1
                
                if (flashed) {
                    octopuses[x, y] = 0
                } else {
                    allFlashed = false
                }
            }
        }
        
        // If all flashed this step we're done
        if (allFlashed) {
            break
        }
        
        step += 1
    }
    
    print("Part 2 answer: \(step)")
}

func day11() {
    let input = getInput("day11", "input.txt")
    
    day11part1(input)
    day11part2(input)
}
