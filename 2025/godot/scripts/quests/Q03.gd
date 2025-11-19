class_name Q03 extends RefCounted


static func part1(data: String) -> String:
    var crates: Array[int] = ECodes.array_int_from_string(data)
    var myset: Set = Set.new()
    myset.add_all(crates)
    var sum: int = 0
    for s: int in myset:
        sum += s
    return str(sum)
    

static func part2(data: String) -> String:
    var crates: Array[int] = ECodes.array_int_from_string(data)
    var myset: Set = Set.new()
    myset.add_all(crates)
    var sum: int = 0
    var sorted: Array = myset.get_as_array()
    sorted.sort()
    for c:int in sorted.slice(0,20):
        sum += c
    return str(sum)


static func part3(data: String) -> String:
    var crates: Array[int] = ECodes.array_int_from_string(data)
    var counter: Counter = Counter.new(crates)
    return str(counter.most_common(1)[0][1])
