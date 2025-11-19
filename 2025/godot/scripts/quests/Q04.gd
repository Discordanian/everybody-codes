class_name Q04 extends RefCounted


static func part1(data: String) -> String:
    var gears: Array[int] = ECodes.array_int_from_string(data)
    var first_gear: int = gears[0]
    var last_gear: int = gears[gears.size() -1]
    
    return str(int(first_gear * 2025/last_gear ))
    

static func part2(data: String) -> String:
    # 10_000_000_000_000
    var gears: Array[int] = ECodes.array_int_from_string(data)
    var first_gear: int = gears[0]
    var last_gear: int = gears[gears.size() -1]
    
    return str(int(10_000_000_000_000 * last_gear/first_gear) +1)


static func part3(data: String) -> String:
    var gears: Array[int] = ECodes.array_int_from_string(data)
    var ratios: Array[float] = []
    assert(gears.size() %2 == 0, "Should be an even number of gears remaining")
    while not gears.is_empty():
        var gear: int = gears.pop_front()
        var next_gear:int = gears.pop_front()
        ratios.append(float(gear)/float(next_gear))
    var product: float = 100
    for ratio: float in ratios:
        product *= ratio
    
    return str(int(product))
