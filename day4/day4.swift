import Foundation

typealias BingoValue = (value: String, marked: Bool)
typealias BingoBoard = Grid<BingoValue>

enum Order {
    case first
    case last
}

func findWinningBoard(_ numbers: [String], _ boards: inout [BingoBoard], _ order: Order) -> (BingoBoard, Int)? {
    for number in numbers {
        guard let winningNumber = Int(number) else {
            return nil
        }
        
        var removed = 0
        
        boardsLoop: for i in 0..<boards.count {
            let index = i - removed
            
            for column in 0..<boards[index].columns {
                for row in 0..<boards[index].rows {
                    if (boards[index][column, row].value == number) {
                        boards[index][column, row].marked = true

                        if (hasBingo(boards[index])) {
                            // We either found the first winning bingo board or the last, either way return it
                            if (order == .first || boards.count == 1) {
                                return (boards[index], winningNumber)
                            }
                            
                            // Found a winning bingo board which is not the last one, continue searching
                            boards.remove(at: index)
                            removed += 1
                            continue boardsLoop
                        }
                    }
                }
            }
        }
    }
    
    return nil
}

func hasBingo(_ board: BingoBoard) -> Bool {
    // Find bingo column
    columnLoop: for column in 0..<board.columns {
        rowLoop: for row in 0..<board.rows {
            if (!board[column, row].marked) {
                continue columnLoop
            }
        }
        
        return true
    }
    
    // Find bingo row
    rowLoop: for row in 0..<board.rows {
        columnLoop: for column in 0..<board.columns {
            if (!board[column, row].marked) {
                continue rowLoop
            }
        }
        
        return true
    }
    
    return false
}

func sumUnmarked(_ board: BingoBoard) -> Int {
    var sum = 0
    
    for row in 0..<board.rows {
        for column in 0..<board.columns {
            if (!board[column, row].marked) {
                if let number = Int(board[column, row].value) {
                    sum += number
                }
            }
        }
    }
    
    return sum
}

func parseBoards(_ rawBoards: [String]) -> [BingoBoard] {
    return rawBoards.map { (rawBoard) -> BingoBoard in
        var board: BingoBoard = Grid(columns: 5, rows: 5, defaultValue: ("", false))
        let rows = rawBoard.components(separatedBy: "\n")
        
        for (rowIndex, row) in rows.enumerated() {
            let values = row.components(separatedBy: " ").filter { !$0.isEmpty }
            
            for (columnIndex, value) in values.enumerated() {
                board[columnIndex, rowIndex] = (value, false)
            }
        }
        
        return board
    }
}

func playBingo(_ input: String, _ order: Order) -> Int? {
    var rawBoards = input.components(separatedBy: "\n\n")
    
    guard let numbers = rawBoards.shift()?.components(separatedBy: ",") else {
        print("Failed to parse bingo numbers")
        return nil
    }

    var boards = parseBoards(rawBoards)
    
    // Find the board that wins first or last depending on input
    guard let (winningBoard, winningNumber) = findWinningBoard(numbers, &boards, order) else {
        print("No winning bingo board")
        return nil
    }
    
    // Calculate answer
    let unmarkedSum = sumUnmarked(winningBoard)
    let answer = unmarkedSum * winningNumber
    
    return answer
}

func day4part1(_ input: String) {
    // Find the bingo board that wins first
    if let answer = playBingo(input, .first) {
        print("Part 1 answer: \(answer)")
    } else {
        print("Failed to calculate part 1 answer")
    }
}

func day4part2(_ input: String) {
    // Find the bingo board that wins last
    if let answer = playBingo(input, .last) {
        print("Part 2 answer: \(answer)")
    } else {
        print("Failed to calculate part 2 answer")
    }
}

func day4() {
    let input = getInput("day4", "input.txt")
    
    day4part1(input)
    day4part2(input)
}
