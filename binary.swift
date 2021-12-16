func binaryTodecimal(_ input: String) -> Int {
    let number = Array(input);
    var result: Int = 0;
    var bit: Int = 0;
    var n: Int = number.count - 1;
    
    while (n >= 0) {
        if (number[n] == "1") {
            result += (1 << (bit));
        }
        
        n = n - 1;
        bit += 1;
    }
    
    return result
}
