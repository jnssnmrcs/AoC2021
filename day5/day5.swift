enum AOCError: Error {
    case invalidInput(line: Int)
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
