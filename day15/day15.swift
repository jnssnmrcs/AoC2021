func parseRiskMap(_ input: String) -> [[Int]] {
    let lines = input.components(separatedBy: "\n")
    let rows = lines.count
    let columns = lines.first!.count
    var grid = Array(repeating: Array(repeating: 0, count: rows), count: columns)
    
    for y in 0..<rows {
        for x in 0..<columns {
            grid[x][y] = Int(lines[y][x])!
        }
    }
    
    return grid
}

func isValid(position: Point, inRiskMap grid: [[Int]]) -> Bool {
    return position.x >= 0 && position.x < grid.count && position.y >= 0 && position.y < grid[position.x].count
}

func astar(fromPoint start: Point, toPoint end: Point, inRiskMap grid: [[Int]]) -> Int? {
    let h: (Point) -> Int = { abs($0.x - end.x) + abs($0.y - end.y) }
    var cameFrom: [Point:Point] = [:]
    var gScore: [Point:Int] = [:]
    var fScore: [Point:Int] = [:]
    var openSet = Set<Point>([start]) // Can be made faster by using a priority queue instead
    
    for y in 0..<grid[0].count {
        for x in 0..<grid.count {
            let position = Point(x, y)
            
            gScore[position] = position == start ? 0 : Int.max
            fScore[position] = position == start ? h(start) : Int.max
        }
    }
    
    while !openSet.isEmpty {
        let current = openSet.min { fScore[$0]! < fScore[$1]! }!
        
        if (current == end) {
            return gScore[end]
        }
        
        openSet.remove(current)
        
        let neighbours = current.getPointsAround().filter { isValid(position: $0, inRiskMap: grid) }
        
        for neighbour in neighbours {
            let gScoreTemp = gScore[current]! + grid[neighbour.x][neighbour.y]
            
            if (gScoreTemp < gScore[neighbour]!) {
                cameFrom[neighbour] = current
                gScore[neighbour] = gScoreTemp
                fScore[neighbour] = gScoreTemp + h(neighbour)
                
                if (!openSet.contains(neighbour)) {
                    openSet.insert(neighbour)
                }
            }
        }
    }
    
    return nil
}

func dijkstras(fromPoint start: Point, toPoint end: Point, inRiskMap grid: [[Int]]) -> Int {
    var unvisited = Set<Point>() // Can be made faster by using a priority queue instead
    var risks: [Point:Int] = [:]
    
    // Insert initial values
    for y in 0..<grid[0].count {
        for x in 0..<grid.count {
            let position = Point(x, y)
            
            risks[position] = position == start ? 0 : Int.max
            unvisited.insert(position)
        }
    }
    
    while !unvisited.isEmpty {
        let current = unvisited.min { risks[$0]! < risks[$1]! }!
        
        if (current == end) {
            break
        }
        
        unvisited.remove(current)
        
        let pointsAround = current.getPointsAround().filter { isValid(position: $0, inRiskMap: grid) && unvisited.contains($0) }
        
        for point in pointsAround {
            let risk = risks[current]! + grid[point.x][point.y]
            
            if (risk < risks[point]!) {
                risks[point] = risk
            }
        }
    }
    
    return risks[end]!
}

func getFullRiskMap(_ grid: [[Int]]) -> [[Int]] {
    let columns = 5 * grid.count
    let rows = 5 * grid[0].count
    var fullGrid = Array(repeating: Array(repeating: 0, count: rows), count: columns)
    
    for y1 in 0..<5 {
        for x1 in 0..<5 {
            for y2 in 0..<grid[0].count {
                for x2 in 0..<grid.count {
                    let newX = x1 * grid.count + x2
                    let newY = y1 * grid[0].count + y2
                    var newRisk = grid[x2][y2] + y1 + x1
                    
                    if (newRisk > 9) {
                        newRisk -= 9
                    }
                    
                    fullGrid[newX][newY] = newRisk
                }
            }
        }
    }
    
    return fullGrid
}

func print(grid: [[Int]]) {
    let rows = grid[0].count
    let columns = grid.count
    
    for y in 0..<rows {
        var row = ""
        for x in 0..<columns {
            row += String(grid[x][y])
        }
        print(row)
    }
}

func day15part1(_ input: String) -> Int {
    let grid = parseRiskMap(input)
    let end = Point(grid.count - 1, grid[0].count - 1)
    let start = Point(0, 0)
    let risk = dijkstras(fromPoint: start, toPoint: end, inRiskMap: grid)

    return risk
}

func day15part2(_ input: String) -> Int {
    let grid = parseRiskMap(input)
    let fullGrid = getFullRiskMap(grid)
    let end = Point(fullGrid.count - 1, fullGrid[0].count - 1)
    let start = Point(0, 0)
    let risk = astar(fromPoint: start, toPoint: end, inRiskMap: fullGrid)

    return risk!
}

func day15() {
    let input = getInput("day15", "input.txt")
    
    evaluateProblem(part: 1, day: "15") { day15part1(input) }
    evaluateProblem(part: 2, day: "15") { day15part2(input) }
}
