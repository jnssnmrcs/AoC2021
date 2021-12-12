typealias Path = [Vertex]
typealias Edge = (String, String)

class Vertex: Hashable, Equatable {
    let name: String
    var adjacent: Set<Vertex>
    
    init (_ name: String) {
        self.name = name
        self.adjacent = Set()
    }
    
    static func == (lhs: Vertex, rhs: Vertex) -> Bool {
        lhs.name == rhs.name
    }
    
    func addAdjacent(Vertex vertex: Vertex) {
        adjacent.insert(vertex)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
