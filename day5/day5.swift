enum AOCError: Error {
    case invalidInput(line: Int)
}

struct Point: Hashable {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    func getPointsBetween(_ point: Point) -> [Point] {
        var points: [Point] = []
        let start = self
        let end = point
        
        if (start.x == end.x) { // Vertical line
            let x = start.x
            let range = start.y > end.y ? end.y...start.y : start.y...end.y
            
            for y in range {
                points.append(Point(x, y))
            }
        } else if (start.y == end.y) { // Horizontal line
            let y = start.y
            let range = start.x > end.x ? end.x...start.x : start.x...end.x
            
            for x in range {
                points.append(Point(x, y))
            }
        } else { // Diagonal line
            var xStep = start.x
            var yStep = start.y
            
            while Point(xStep, yStep) != end {
                points.append(Point(xStep, yStep))
                
                xStep += start.x < end.x ? 1 : -1
                yStep += start.y < end.y ? 1 : -1
            }
            
            points.append(Point(xStep, yStep))
        }
        
        return points
    }
}

typealias Line = (start: Point, end: Point)

func parsePoint(_ rawPoint: String) -> Point? {
    let parts = rawPoint.components(separatedBy: ",")
    
    if (parts.count != 2) {
        return nil
    }
    
    guard let x = Int(parts[0]), let y = Int(parts[1]) else {
        return nil
    }
    
    return Point(x, y)
}

func parseLine(_ rawLine: String) -> Line? {
    let points = rawLine.components(separatedBy: " -> ")
    
    if (points.count != 2) {
        return nil
    }
    
    guard let start = parsePoint(points[0]), let end = parsePoint(points[1]) else {
        return nil
    }
    
    return (start, end)
}

func parseLines(_ input: String) throws -> [Line] {
    let rawLines = input.components(separatedBy: "\n")
    let lines = try rawLines.enumerated().map { (index, rawLine) -> Line in
        guard let line = parseLine(rawLine) else {
            throw AOCError.invalidInput(line: index + 1)
        }
        
        return line
    }
    
    return lines
}

func getAllPointsInLine(_ line: Line) -> [Point] {
    return line.start.getPointsBetween(line.end)
}

func countDuplicates(_ points: [Point]) -> Int {
    var dict: [Point: Int] = [:]
    var duplicates = 0
    
    for point in points {
        dict[point] = dict[point] == nil ? 1 : dict[point]! + 1
        
        // Only count each point with 2 or more occurrences once
        if (dict[point] == 2) {
            duplicates += 1
        }
    }
    
    return duplicates
}

func day5part1(_ input: String) {
    do {
        let lines = try parseLines(input)
        let filteredLines = lines.filter { (line) -> Bool in
            return line.start.x == line.end.x || line.start.y == line.end.y
        }
        var points: [Point] = []
        
        for line in filteredLines {
            points += getAllPointsInLine(line)
        }
        
        let duplicates = countDuplicates(points)

        print("Part 1 answer: \(duplicates)")
    } catch AOCError.invalidInput(let line) {
        print("Invalid input at line \(line)")
    } catch {
        print("Failed to calculate answer")
    }
}

func day5part2(_ input: String) {
    do {
        let lines = try parseLines(input)
        var points: [Point] = []
        
        for line in lines {
            points += getAllPointsInLine(line)
        }
        
        let duplicates = countDuplicates(points)

        print("Part 2 answer: \(duplicates)")
    } catch AOCError.invalidInput(let line) {
        print("Invalid input at line \(line)")
    } catch {
        print("Failed to calculate answer")
    }
}

func day5() {
    let input = getInput("day5", "input.txt")
    
    day5part1(input)
    day5part2(input)
}
