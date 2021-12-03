import Foundation

func getInput(_ day: String, _ fileName: String) -> String {
    let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let inputFile = folder!.appendingPathComponent("Marcus/AoC2021/\(day)/\(fileName)")
    let input = try? String(contentsOf: inputFile, encoding: .utf8)
    
    return input!.trimmingCharacters(in: CharacterSet(charactersIn: " \n"))
}
