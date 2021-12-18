struct Point: Hashable {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    func getPointsAround(includingDiagonals: Bool = false) -> [Point] {
        var points = [
            Point(x, y - 1),
            Point(x, y + 1),
            Point(x - 1, y),
            Point(x + 1, y),
        ]
        
        if (includingDiagonals) {
            points += [
                Point(x - 1, y - 1),
                Point(x + 1, y + 1),
                Point(x - 1, y + 1),
                Point(x + 1, y - 1),
            ]
        }
        
        return points
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
