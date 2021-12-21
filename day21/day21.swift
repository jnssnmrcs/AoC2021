protocol Dice {
    var rolls: Int { get }
    mutating func roll() -> Int
}

struct DeterministicDice: Dice {
    var value = 0
    var rolls = 0
    
    mutating func roll() -> Int {
        value += 1
        rolls += 1
        
        if (value > 100) {
            value = 1
        }
        
        return value
    }
}

struct Player {
    var position: Int
    var score: Int
    
    init(startPosition: Int) {
        position = startPosition
        score = 0
    }
    
    mutating func move(steps: Int) {
        position += steps
        
        while (position > 10) {
            position -= 10
        }
        
        score += position
    }
}

struct DeterministicGame {
    var player1: Player
    var player2: Player
    var currentPlayer: Int
    var winningScore: Int
    var die: DeterministicDice
    var done: Bool { player1.score >= winningScore || player2.score >= winningScore }
    var loser: Player { player1.score < player2.score ? player1 : player2 }
    
    init(player1Start: Int, player2Start: Int, winningScore: Int) {
        self.die = DeterministicDice()
        self.winningScore = winningScore
        
        player1 = Player(startPosition: player1Start)
        player2 = Player(startPosition: player2Start)
        currentPlayer = 1
    }
    
    mutating func takeTurn() {
        let steps = die.roll() + die.roll() + die.roll()
        
        if (currentPlayer == 1) {
            player1.move(steps: steps)
        } else {
            player2.move(steps: steps)
        }
        
        currentPlayer = currentPlayer == 1 ? 2 : 1
    }
}

typealias DiracGame = (position1: Int, position2: Int, score1: Int, score2: Int, player1: Bool, games: Int)

func getNewPosition(position: Int, steps: Int) -> Int {
    var newPosition = position + steps
    
    while (newPosition > 10) {
        newPosition -= 10
    }
    
    return newPosition
}

func day21part1(_ input: String) -> Int {
    let startingPositions = input.components(separatedBy: "\n")
    let start1 = Int(String(startingPositions.first!.last!))!
    let start2 = Int(String(startingPositions.last!.last!))!
    var game = DeterministicGame(player1Start: start1, player2Start: start2, winningScore: 1000)

    repeat {
        game.takeTurn()
    } while (!game.done)

    return game.loser.score * game.die.rolls
}

func day21part2(_ input: String) -> Int {
    let startingPositions = input.components(separatedBy: "\n")
    let start1 = Int(String(startingPositions.first!.last!))!
    let start2 = Int(String(startingPositions.last!.last!))!
    var games: [DiracGame] = [(start1, start2, 0, 0, true, 1)]
    var player1Wins = 0
    var player2Wins = 0
    
    while (!games.isEmpty) {
        let nextGame = games.popLast()!
        let newGames = Array(repeating: nextGame, count: 7)
        let moves = [(3, 1), (4, 3), (5, 6), (6, 7), (7, 6), (8, 3), (9, 1)]
        
        for (index, (steps, numberOfGames)) in moves.enumerated() {
            var game = newGames[index]
            
            if (game.player1) {
                let newPosition = getNewPosition(position: game.position1, steps: steps)
                
                game.score1 += newPosition
                game.position1 = newPosition
            } else {
                let newPosition = getNewPosition(position: game.position2, steps: steps)
                
                game.score2 += newPosition
                game.position2 = newPosition
            }
            
            game.player1 = !game.player1
            game.games *= numberOfGames
            
            if (game.score1 >= 21) {
                player1Wins += game.games
            } else if (game.score2 >= 21) {
                player2Wins += game.games
            } else {
                games.append(game)
            }
        }
    }
    
    return max(player1Wins, player2Wins)
}

func day21() {
    let input = getInput("day21", "input.txt")

    evaluateProblem(part: 1, day: "21") { day21part1(input) }
    evaluateProblem(part: 2, day: "21") { day21part2(input) }
}
