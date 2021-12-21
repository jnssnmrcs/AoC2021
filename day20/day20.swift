fileprivate typealias Pixel = (x: Int, y: Int)
fileprivate typealias Image = (pixels: [[Int]], columns: Int, rows: Int)

fileprivate func parseInputData(_ input: String) -> (algorithm: String, image: Image) {
    let parts = input.components(separatedBy: "\n\n")
    let lines = parts[1].components(separatedBy: "\n")
    let algorithm = parts[0]
    let rows = lines.count + 4
    let columns = lines.first!.count + 4
    let pixels = Array.init(repeating: Array.init(repeating: 0, count: rows), count: columns)
    var image: Image = (pixels, columns, rows)
    
    for y in 2..<(rows - 2) {
        for x in 2..<(columns - 2) {
            image.pixels[x][y] = lines[y - 2][x - 2] == "#" ? 1 : 0
        }
    }
    
    return (algorithm, image)
}

fileprivate func print(image: Image) {
    for y in 2..<(image.rows - 2) {
        var line = ""
        
        for x in 2..<(image.columns - 2) {
            line += image.pixels[x][y] == 1 ? "#" : "."
        }
        
        print(line)
    }
    
    print("")
}

fileprivate func getAlgorithmIndex(forPixel pixel: Pixel, inImage image: Image) -> Int {
    var binaryString = ""
    
    for y in (pixel.y - 1)...(pixel.y + 1) {
        for x in (pixel.x - 1)...(pixel.x + 1) {
            binaryString += String(image.pixels[x][y])
        }
    }
    
    return binaryTodecimal(binaryString)
}

fileprivate func enhance(image: Image, withAlgorithm algorithm: String) -> Image {
    let infinitePixel = image.pixels[0][0] == 1 ? algorithm.last! : algorithm.first!
    let pixels = Array.init(repeating: Array.init(repeating: infinitePixel == "#" ? 1 : 0, count: image.rows + 2), count: image.columns + 2)
    var enhancedImage: Image = (pixels, image.columns + 2, image.rows + 2)
    
    for y in 1..<(image.rows - 1) {
        for x in 1..<(image.columns - 1) {
            let index = getAlgorithmIndex(forPixel: Pixel(x, y), inImage: image)

            enhancedImage.pixels[x + 1][y + 1] = algorithm[index] == "#" ? 1 : 0
        }
    }
    
    return enhancedImage
}

fileprivate func day20part1(_ input: String) -> Int {
    var (algorithm, image) = parseInputData(input)
    var litPixels = 0
    
    image = enhance(image: image, withAlgorithm: algorithm)
    image = enhance(image: image, withAlgorithm: algorithm)
    
    for x in 2..<(image.columns - 2) {
        for y in 2..<(image.rows - 2) {
            litPixels += image.pixels[x][y]
        }
    }
    
    return litPixels
}

fileprivate func day20part2(_ input: String) -> Int {
    var (algorithm, image) = parseInputData(input)
    var litPixels = 0
    
    for _ in 0..<50 {
        image = enhance(image: image, withAlgorithm: algorithm)
    }
    
    for x in 2..<(image.columns - 2) {
        for y in 2..<(image.rows - 2) {
            litPixels += image.pixels[x][y]
        }
    }
    
    return litPixels
}

func day20() {
    let input = getInput("day20", "input.txt")

    evaluateProblem(part: 1, day: "20") { day20part1(input) }
    evaluateProblem(part: 2, day: "20") { day20part2(input) }
}
