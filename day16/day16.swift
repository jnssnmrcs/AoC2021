fileprivate let hexBinaryMap: [Character:String] = [
    "0": "0000",
    "1": "0001",
    "2": "0010",
    "3": "0011",
    "4": "0100",
    "5": "0101",
    "6": "0110",
    "7": "0111",
    "8": "1000",
    "9": "1001",
    "A": "1010",
    "B": "1011",
    "C": "1100",
    "D": "1101",
    "E": "1110",
    "F": "1111",
]

fileprivate let idOperandMap: [Int:Operand] = [
    0: .sum,
    1: .product,
    2: .min,
    3: .max,
    5: .greaterThan,
    6: .lessThan,
    7: .equalTo,
]

fileprivate enum Operand {
    case lessThan
    case greaterThan
    case sum
    case product
    case min
    case max
    case equalTo
}

fileprivate protocol Packet {
    var version: Int { get }
    var id: Int { get }
    func evaluate() -> Int
}

fileprivate struct ValuePacket: Packet {
    var version: Int
    var id: Int
    var value: Int
    
    init(_ version: Int, _ id: Int, _ value: Int) {
        self.version = version
        self.id = id
        self.value = value
    }
    
    func evaluate() -> Int {
        return value
    }
}

fileprivate struct OperatorPacket: Packet {
    var version: Int
    var id: Int
    var packets: [Packet]
    var operand: Operand
    
    init(_ version: Int, _ id: Int, _ packets: [Packet]) {
        self.version = version
        self.id = id
        self.packets = packets
        self.operand = idOperandMap[id]!
    }
    
    private func sum() -> Int {
        return packets.reduce(0) { $0 + $1.evaluate() }
    }
    
    private func product() -> Int {
        return packets.reduce(1) { $0 * $1.evaluate() }
    }
    
    private func max() -> Int {
        return packets.map { $0.evaluate() }.max { $0 < $1 }!
    }
    
    private func min() -> Int {
        return packets.map { $0.evaluate() }.min { $0 < $1 }!
    }
    
    private func equalTo() -> Int {
        let result = packets.first!.evaluate() == packets.last!.evaluate()
        
        return result ? 1 : 0
    }
    
    private func lessThan() -> Int {
        let result = packets.first!.evaluate() < packets.last!.evaluate()
        
        return result ? 1 : 0
    }
    
    private func greaterThan() -> Int {
        let result = packets.first!.evaluate() > packets.last!.evaluate()
        
        return result ? 1 : 0
    }
    
    func evaluate() -> Int {
        switch (operand) {
        case .lessThan: return lessThan()
        case .greaterThan: return greaterThan()
        case .sum: return sum()
        case .product: return product()
        case .min: return min()
        case .max: return max()
        case .equalTo: return equalTo()
        }
    }
}

fileprivate func parseValuePacket(version: Int, id: Int, _ input: String, _ pointer: inout String.Index) -> ValuePacket {
    var value = ""
    
    while true {
        let index = input.index(pointer, offsetBy: 5)
        let group = input[pointer..<index]
        
        pointer = index
        value += group[group.index(after: group.startIndex)..<group.endIndex]
        
        if (group.first == "0") {
            return ValuePacket(version,  id, binaryTodecimal(value))
        }
    }
}

fileprivate func parseOperatorPacket(version: Int, id: Int, _ input: String, _ pointer: inout String.Index) -> OperatorPacket {
    var packets: [Packet] = []
    
    // Read length ID
    let lengthTypeIndex = input.index(pointer, offsetBy: 1)
    let lengthTypeID = binaryTodecimal(String(input[pointer..<lengthTypeIndex]))
    
    pointer = lengthTypeIndex
    
    // Read length
    let lengthOffset = lengthTypeID == 0 ? 15 : 11
    let lengthIndex = input.index(pointer, offsetBy: lengthOffset)
    let length = binaryTodecimal(String(input[pointer..<lengthIndex]))
    
    pointer = lengthIndex
    
    // Read contained packets
    if (lengthTypeID == 0) {
        let packetsIndex = input.index(pointer, offsetBy: length)
        let packetsInput = String(input[pointer..<packetsIndex])
        
        pointer = packetsIndex
        
        var packetsPointer = packetsInput.startIndex
        
        while true {
            let packet = parsePacket(packetsInput, &packetsPointer)
            
            packets.append(packet)
            
            if (packetsPointer == packetsInput.endIndex) {
                break
            }
        }
    } else {
        let numberOfPackets = length
        
        for _ in 0..<numberOfPackets {
            let packet = parsePacket(input, &pointer)
            
            packets.append(packet)
        }
    }
    
    return OperatorPacket(version, id, packets)
}

fileprivate func parsePacket(_ input: String, _ pointer: inout String.Index) -> Packet {
    // Read version
    let versionIndex = input.index(pointer, offsetBy: 3)
    let version = binaryTodecimal(String(input[pointer..<versionIndex]))
    
    pointer = versionIndex
    
    // Read ID
    let idIndex = input.index(pointer, offsetBy: 3)
    let id = binaryTodecimal(String(input[pointer..<idIndex]))
    
    pointer = idIndex

    // Read contents
    return id == 4 ? parseValuePacket(version: version, id: id, input, &pointer) : parseOperatorPacket(version: version, id: id, input, &pointer)
}

fileprivate func getVersionSum(ofPacket packet: Packet) -> Int {
    if let valuePacket = packet as? ValuePacket {
        return valuePacket.version
    } else {
        let operatorPacket = packet as! OperatorPacket
        
        return operatorPacket.packets.reduce(operatorPacket.version) { $0 + getVersionSum(ofPacket: $1) }
    }
}

fileprivate func day16part1(_ input: String) -> Int {
    let converted = input.reduce("") { $0 + hexBinaryMap[$1]! }
    var pointer = converted.startIndex
    let packet = parsePacket(converted, &pointer)
    
    return getVersionSum(ofPacket: packet)
}

fileprivate func day16part2(_ input: String) -> Int {
    let converted = input.reduce("") { $0 + hexBinaryMap[$1]! }
    var pointer = converted.startIndex
    let packet = parsePacket(converted, &pointer)
    
    return packet.evaluate()
}

func day16() {
    let input = getInput("day16", "input.txt")
    
    evaluateProblem(part: 1, day: "16") { day16part1(input) }
    evaluateProblem(part: 2, day: "16") { day16part2(input) }
}
