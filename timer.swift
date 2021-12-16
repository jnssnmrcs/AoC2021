import Foundation

func evaluateProblem(part: Int, day: String, problemBlock: () -> Int) {
    let start = DispatchTime.now()
    let answer = problemBlock()
    let end = DispatchTime.now()
    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    let timeInterval = Int(trunc(Double(nanoTime) / 1_000_000))

    print("Day \(day) part \(part) answer in \(timeInterval)ms:")
    print(answer)
    print("")
}
