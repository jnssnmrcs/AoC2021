import Foundation

typealias VertexFilter = (Vertex, Path) -> Bool

extension Vertex {
    func isSmallCave() -> Bool {
        let lowers = CharacterSet.lowercaseLetters
        
        return !self.isStart() && !self.isEnd() && self.name.unicodeScalars.allSatisfy {
            lowers.contains($0)
        }
    }
    
    func isBigCave() -> Bool {
        let uppers = CharacterSet.uppercaseLetters
        
        return !self.isStart() && !self.isEnd() && self.name.unicodeScalars.allSatisfy {
            uppers.contains($0)
        }
    }
    
    func isEnd() -> Bool {
        return self.name == "end"
    }
    
    func isStart() -> Bool {
        return self.name == "start"
    }
}

func parseEdges(_ input: String) -> [Edge] {
    let lines = input.components(separatedBy: "\n")
    var edges: [Edge] = []
    
    for line in lines {
        let parts = line.components(separatedBy: "-")
        let edge = (parts[0], parts[1])
        
        edges.append(edge)
    }
    
    return edges
}

func parseGraph(_ input: String) -> (start: Vertex, end: Vertex) {
    let edges = parseEdges(input)
    var vertices = Set<Vertex>()
    var start: Vertex?
    var end: Vertex?
    
    for edge in edges {
        let fromVertex = vertices.first { $0.name == edge.0 } ?? Vertex(edge.0)
        let toVertex = vertices.first { $0.name == edge.1 } ?? Vertex(edge.1)
        
        fromVertex.addAdjacent(Vertex: toVertex)
        toVertex.addAdjacent(Vertex: fromVertex)
        
        vertices.insert(fromVertex)
        vertices.insert(toVertex)
        
        if (start == nil) {
            if (toVertex.isStart()) {
                start = toVertex
            } else if (fromVertex.isStart()) {
                start = fromVertex
            }
        }
        
        if (end == nil) {
            if (toVertex.isEnd()) {
                end = toVertex
            } else if (fromVertex.isEnd()) {
                end = fromVertex
            }
        }
    }
    
    return (start!, end!)
}

func findPaths(fromVertex current: Vertex, toVertex to: Vertex, _ visited: Path = [], withFilter filter: VertexFilter) -> Int {
    if (current == to) {
        return 1
    }
    
    var paths = 0
    var currentVisited = visited
    
    currentVisited.append(current)

    for next in current.adjacent where filter(next, currentVisited) {
        paths += findPaths(fromVertex: next, toVertex: to, currentVisited, withFilter: filter)
    }
    
    return paths
}

func day12part1(_ input: String) {
    let (start, end) = parseGraph(input)
    let paths = findPaths(fromVertex: start, toVertex: end) { (next, visited) -> Bool in
        let smallCaves = visited.filter { $0.isSmallCave() }
        
        return !next.isStart() && !smallCaves.contains(next)
    }
    
    print("Part 1 answer: \(paths)")
}

func day12part2(_ input: String) {
    let (start, end) = parseGraph(input)
    let paths = findPaths(fromVertex: start, toVertex: end) { (next, visited) -> Bool in
        let smallCaves = visited.filter { $0.isSmallCave() }
        let duplicate = smallCaves.duplicates().first
        
        return !next.isStart() && (next.isBigCave() || duplicate == nil || !smallCaves.contains(next))
    }

    print("Part 2 answer: \(paths)")
}

func day12() {
    let input = getInput("day12", "input.txt")
    
    day12part1(input)
    day12part2(input)
}
