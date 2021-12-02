import Foundation

func getInput(_ day: String) -> String {
    let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let inputFile = folder!.appendingPathComponent("Marcus/AoC2021/\(day)/input.txt")
    let input = try? String(contentsOf: inputFile, encoding: .utf8)
    
    return input!
}
