struct Grid<T> {
    let columns: Int
    let rows: Int
    var grid: [T]
    
    init(columns: Int, rows: Int, defaultValue: T) {
        self.columns = columns
        self.rows = rows
        
        grid = Array(repeating: defaultValue, count: rows * columns)
    }
    
    func indexIsValid(column: Int, row: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    subscript(column: Int, row: Int) -> T {
        get {
            assert(indexIsValid(column: column, row: row), "Index out of range")
            return grid[(row * columns) + column]
        }
        mutating set {
            assert(indexIsValid(column: column, row: row), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}
