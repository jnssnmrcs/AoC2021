typealias Fold = (axis: String, value: Int)
typealias Paper = (values: [[Bool]], columns: Int, rows: Int)

func parseInput(_ input: String) -> (dots: [Point], folds: [Fold], columns: Int, rows: Int) {
    let parts = input.components(separatedBy: "\n\n")
    var columns = 0
    var rows = 0
    
    let dots: [Point] = parts[0].components(separatedBy: "\n").map {
        let foldParts = $0.components(separatedBy: ",")
        let point = Point(Int(foldParts[0])!, Int(foldParts[1])!)
        
        if (point.x + 1 > columns) {
            columns = point.x + 1
        }
        
        if (point.y + 1 > rows) {
            rows = point.y + 1
        }
        
        return point
    }
    
    let folds: [Fold] = parts[1].components(separatedBy: "\n").map {
        let index = $0.index($0.startIndex, offsetBy: 11)
        let foldParts = $0.suffix(from: index).components(separatedBy: "=")
        
        return (foldParts[0], Int(foldParts[1])!)
    }
    
    return (dots, folds, columns, rows)
}

func print(paper: Paper) {
    for y in 0..<paper.rows {
        var row = ""
        for x in 0..<paper.columns {
            if (paper.values[x][y]) {
                row += "#"
            } else {
                row += " "
            }
        }
        
        print(row)
    }
}

func foldOnce(paper: Paper, fold: Fold) -> Paper {
    var (values, columns, rows) = paper
    let (axis, value) = fold
    
    let fromY = axis == "x" ? 0 : value + 1
    let fromX = axis == "x" ? value + 1 : 0
    
    for x in fromX..<columns {
        for y in fromY..<rows {
            let newX = axis == "x" ? 2 * value - x : x
            let newY = axis == "x" ? y : 2 * value - y
            
            if (newX >= 0 && newY >= 0 && values[x][y]) {
                values[newX][newY] = true
            }
        }
    }
    
    // Update size of the paper after it has been folded
    if (axis == "x") {
        columns = value
    } else {
        rows = value
    }
    
    return (values, columns, rows)
}

func foldMultiple(paper: Paper, folds: [Fold]) -> Paper {
    var foldedPaper = paper
    
    for fold in folds {
        foldedPaper = foldOnce(paper: foldedPaper, fold: fold)
    }
    
    return foldedPaper
}

func getPaper(dots: [Point], columns: Int, rows: Int) -> Paper {
    var values: [[Bool]] = []
    
    for x in 0..<columns {
        values.append([])

        for _ in 0..<rows {
            values[x].append(false)
        }
    }
    
    for dot in dots {
        values[dot.x][dot.y] = true
    }
    
    return (values, columns, rows)
}

func day13part1(_ input: String) {
    let (dots, folds, columns, rows) = parseInput(input)
    let paper = getPaper(dots: dots, columns: columns, rows: rows)
    let foldedPaper = foldOnce(paper: paper, fold: folds.first!)
    var visible = 0
    
    for y in 0..<foldedPaper.rows {
        for x in 0..<foldedPaper.columns {
            if (foldedPaper.values[x][y]) {
                visible += 1
            }
        }
    }
    
    print("Part 1 answer: \(visible)")
}

func day13part2(_ input: String) {
    let (dots, folds, columns, rows) = parseInput(input)
    let paper = getPaper(dots: dots, columns: columns, rows: rows)
    let foldedPaper = foldMultiple(paper: paper, folds: folds)
    
    print("Part 2 answer:")
    print(paper: foldedPaper)
}

func day13() {
    let input = getInput("day13", "input.txt")
    
    day13part1(input)
    day13part2(input)
}
