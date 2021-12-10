typealias ChunkType = (opener: Character, closer: Character)

let CHUNK_TYPES: [ChunkType] = [
    ("(", ")"),
    ("{", "}"),
    ("[", "]"),
    ("<", ">"),
]

func day10part1(_ input: String) {
    let chunks = input.components(separatedBy: "\n")
    let pointMap: [Character:Int] = [
        ")": 3,
        "]": 57,
        "}": 1197,
        ">": 25137,
    ]
    var points = 0
    
    chunkLoop: for chunk in chunks {
        var opened: [Character] = []
        
        for character in chunk {
            let chunkType = CHUNK_TYPES.first { $0.opener == character || $0.closer == character }!
            
            if (chunkType.opener == character) {
                opened.append(character)
            } else if (chunkType.opener != opened.last) { // Corrupted chunk
                points += pointMap[character]!
                continue chunkLoop
            } else {
                opened.removeLast()
            }
        }
    }
    
    print("Part 1 answer: \(points)")
}

typealias IncompleteChunk = (chunk: String, opened: [Character])

func day10part2(_ input: String) {
    let chunks = input.components(separatedBy: "\n")
    let pointMap: [Character:Int] = [
        ")": 1,
        "]": 2,
        "}": 3,
        ">": 4,
    ]
    var scores: [Int] = []
    
    chunkLoop: for chunk in chunks {
        var opened: [Character] = []
        var points = 0
        
        for character in chunk {
            let chunkType = CHUNK_TYPES.first { $0.opener == character || $0.closer == character }!
            
            if (chunkType.opener == character) {
                opened.append(character)
            } else if (chunkType.opener != opened.last) { // Corrupted chunk
                continue chunkLoop
            } else {
                opened.removeLast() // Close the current chunk
            }
        }
        
        let missingClosers = opened.reversed().map { (opener) -> Character in
            return CHUNK_TYPES.first { $0.opener == opener }!.closer
        }
        
        for closer in missingClosers {
            points = points * 5 + pointMap[closer]!
        }
        
        scores.append(points)
    }
    
    let sorted = scores.sorted()
    let middleScore = sorted[(sorted.count - 1) / 2]
    
    print("Part 2 answer: \(middleScore)")
}

func day10() {
    let input = getInput("day10", "input.txt")
    
    day10part1(input)
    day10part2(input)
}
