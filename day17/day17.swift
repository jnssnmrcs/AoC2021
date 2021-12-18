fileprivate typealias TargetBounds = (x: (min: Int, max: Int), y: (min: Int, max: Int))
fileprivate typealias Hit = (xVelocity: Int, yVelocity: Int, maxHeight: Int)

fileprivate func parseInput(_ input: String) -> TargetBounds {
    let parts = input.components(separatedBy: ": ").last!.components(separatedBy: ", ")
    let xRange = parts[0].components(separatedBy: "=").last!.components(separatedBy: "..")
    let yRange = parts[1].components(separatedBy: "=").last!.components(separatedBy: "..")
    
    return ((Int(xRange.first!)!, Int(xRange.last!)!), (Int(yRange.first!)!, Int(yRange.last!)!))
}

fileprivate func forEachHit(target: TargetBounds, onHit: (Hit) -> Void) {
    for yStartVelocity in min(target.y.min, 0)...1000 { // Not sure what a good upper bound is here...
        for xStartVelocity in 0...target.x.max {
            var x = 0
            var y = 0
            var xVelocity = xStartVelocity
            var yVelocity = yStartVelocity
            var maxHeight = Int.min
            
            while true {
                x += xVelocity
                y += yVelocity
                
                // Update max height
                if (y > maxHeight) {
                    maxHeight = y
                }
                
                // Hit
                if (target.x.min <= x && x <= target.x.max && target.y.min <= y && y <= target.y.max) {
                    let hit: Hit = (xStartVelocity, yStartVelocity, maxHeight)
                    
                    onHit(hit)
                }
                
                // OverShoot
                if (x > target.x.max || y < target.y.min) {
                    break
                }
                
                yVelocity -= 1
                xVelocity -= xVelocity == 0 ? 0 : 1
            }
        }
    }
}

fileprivate func day17part1(_ input: String) -> Int {
    let target: TargetBounds = parseInput(input)
    var highest: Hit = (0, 0, Int.min)
    
    forEachHit(target: target) {
        if (highest.maxHeight < $0.maxHeight) {
            highest = $0
        }
    }
    
    return highest.maxHeight
}

fileprivate func day17part2(_ input: String) -> Int {
    let target: TargetBounds = parseInput(input)
    var hits = Set<String>()
    
    forEachHit(target: target) {
        hits.insert(String($0.xVelocity) + String($0.yVelocity))
    }
    
    return hits.count
}

func day17() {
    let input = getInput("day17", "input.txt")

    evaluateProblem(part: 1, day: "17") { day17part1(input) }
    evaluateProblem(part: 2, day: "17") { day17part2(input) }
}
