class_name Q16 extends RefCounted

const BLOCKS_TOTAL: int = 202_520_252_025_000
const WALL_LENGTH: int =   94_439_495_762_954 

var numbers: Array[int]
var memo: Dictionary

func col_value(col: int, response: Array[int]) -> int:
    var retval: int = 0
    for r: int in response:
        if col % r ==0:
            retval += 1
    return retval

func range_length(start: int, end: int, step: int) -> int:
    var retval: int = 0
    if memo.has([start, end, step]):
        return memo[[start, end, step]]
    while start < end:
        retval += 1
        start += step
    memo[[start, end, step]] = retval
    return retval

func build_possible(wall_length: int) -> bool:
    var ncols: int = 0
    
    for  n: int in numbers:
        ncols += range_length(n - 1, wall_length, n )
    return ncols <= BLOCKS_TOTAL
           


func part1(data: String) -> String:
    numbers = ECodes.array_int_from_string(data)
    var sum: int = 0
    for i: int in range(90):
        for n: int in numbers:
            if (i+1) % n == 0:
                sum += 1
    return str(sum)


func part2(data: String) -> String:
    numbers = ECodes.array_int_from_string(data)
    var ans: Array[int] = []
    var retval: int = 1
    
    for idx: int in range(numbers.size()):
        var col: int = idx + 1
        var tot: int = numbers[idx]
        var amt: int = col_value(col, ans)
        if col == 5:
            print(col, tot, amt, ans)
        if (tot - amt) > 0:
            ans.push_back(col)
            retval *= col
        
        
    return str(retval)

func part3(data: String) -> String:
    numbers = ECodes.array_int_from_string(data)
    var _ans: Array[int] = []
    var retval: int = 1    
    var columns: PackedInt32Array = []
    columns.resize(numbers.size())
    columns.fill(0)
    
    var values: Array[int] = numbers.duplicate()
    for i: int in range(numbers.size()):
        var col: int = i + 1
        var val: int = values[i]
        if val == 0:
            continue
        
        retval *= val * col
        var xtra_columns: PackedInt32Array = []
        xtra_columns.resize(val)
        xtra_columns.fill(col)
        columns.append_array(xtra_columns)
        
        for x: int in range(col - 1, numbers.size(), col):
            columns[x] += val
            values[x] -= val
        
        numbers.clear()
        for c: int in columns:
            numbers.append(c)
        
        var left: int = 0
        var right: int = WALL_LENGTH
        while left <= right:
            @warning_ignore("integer_division")
            var mid: int = (left + right) / 2
            if build_possible(mid):
                retval = mid
                left = mid + 1
            else:
                right = mid - 1
            
    return str(retval)
