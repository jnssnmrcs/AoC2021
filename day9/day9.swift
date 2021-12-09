typealias Basin = [Point]
typealias HeightMap = Grid<Int>

func parseHeightMap(_ input: String) -> HeightMap {
    let lines = input.components(separatedBy: "\n")
    let rows = lines.count
    let columns = lines.first!.count
    var heightMap = Grid(columns: columns, rows: rows, defaultValue: 0)
    
    for row in 0..<rows {
        for column in 0..<columns {
            heightMap[column, row] = Int(lines[row][column])!
        }
    }
    
    return heightMap
}

func getLowPoints(inHeightMap heightMap: HeightMap) -> [Point] {
    var lowPoints: [Point] = []
    
    for column in 0..<heightMap.columns {
        for row in 0..<heightMap.rows {
            let height = heightMap[column, row]
            let points = getPoints(aroundPoint: Point(column, row))
            
            let isLowPoint = points.allSatisfy {
                let pointHeight = heightMap.indexIsValid(column: $0.x, row: $0.y) ? heightMap[$0.x, $0.y] : 9
                
                return height < pointHeight
            }
            
            if (isLowPoint) {
                lowPoints.append(Point(column, row))
            }
        }
    }
    
    return lowPoints
}

func getPoints(aroundPoint point: Point) -> [Point] {
    return [
        Point(point.x, point.y - 1),
        Point(point.x, point.y + 1),
        Point(point.x - 1, point.y),
        Point(point.x + 1, point.y),
    ]
}

func getBasinHelper(aroundPoint point: Point, inHeightMap heightMap: HeightMap, _ basin: inout Basin) {
    let surroundingPoints = getPoints(aroundPoint: point).filter {
        return heightMap.indexIsValid(column: $0.x, row: $0.y) && heightMap[$0.x, $0.y] != 9
    }

    for surroundingPoint in surroundingPoints {
        if (!basin.contains(surroundingPoint)) {
            basin.append(surroundingPoint)
            getBasinHelper(aroundPoint: surroundingPoint, inHeightMap: heightMap, &basin)
        }
    }
}

func getBasin(aroundPoint point: Point, inHeightMap heightMap: HeightMap) -> Basin {
    var basin: Basin = []
    
    basin.append(point)
    
    getBasinHelper(aroundPoint: point, inHeightMap: heightMap, &basin)

    return basin
}

func getBasins(inHeightMap heightMap: HeightMap) -> [Basin] {
    var basins: [Basin] = []
    let lowPoints = getLowPoints(inHeightMap: heightMap)
    
    for lowPoint in lowPoints {
        let basin = getBasin(aroundPoint: lowPoint, inHeightMap: heightMap)
        
        basins.append(basin)
    }
    
    return basins.sorted { $0.count > $1.count }
}

func day9part1(_ input: String) {
    let heightMap = parseHeightMap(input)
    let lowPoints = getLowPoints(inHeightMap: heightMap)
    let sum = lowPoints.reduce(0) { $0 + heightMap[$1.x, $1.y] + 1 }
    
    print("Part 1 answer: \(sum)")
}

func day9part2(_ input: String) {
    let heightMap = parseHeightMap(input)
    let basins = getBasins(inHeightMap: heightMap)
    let answer = basins[0].count * basins[1].count * basins[2].count

    print("Part 2 answer: \(answer)")
}

func day9() {
    let input = getInput("day9", "input.txt")
    
    day9part1(input)
    day9part2(input)
}
