class_name Q05 extends RefCounted

static func _spine_int_array(spine: Array[Array]) -> Array[int]:
    var retval: Array[int] = []
    for rib: Array[Variant] in spine:
        var num_str: String = ""
        for cell: Variant in rib:
            if not cell == null:
                num_str += str(cell)
        retval.append(int(num_str))
    return retval

## Return [id, quality, rib_int_array]
static func _quality(data: String) -> Array[Variant]:
    var numbers: Array[int] = ECodes.array_int_from_string(data)
    var spine: Array[Array] = []
    print(data)
    assert(numbers.size() > 2, "Should have recevied lots of numbers")
    var id: int = numbers.pop_front()
    print("Working on ID :", id)
    for number: int in numbers:
        if numbers.is_empty():
            spine.append([null, number, null])
            continue
        var placed: bool = false
        for rib: Array[Variant] in spine:
            if not placed and rib[0] == null and number < rib[1]:
                rib[0] = number
                placed = true
                continue
            if not placed and rib[2] == null and number > rib[1]:
                rib[2] = number
                placed = true
                continue
        if not placed:
            spine.append([null, number, null])
    var answer: String = ""
    for rib: Array[Variant] in spine:
        answer += str(rib[1])
    return [id, int(answer), _spine_int_array(spine)]

static func _fishbone_sort(lhs: Array[Variant], rhs: Array[Variant]) -> bool:
    if lhs[1] != rhs[1]:
        return rhs[1] > lhs[1]
    var max_idx: int = max(lhs[2].size(), rhs[2].size())
    for idx: int in range(max_idx):
        if lhs[2][idx] != rhs[2][idx]:
            return rhs[2][idx] > lhs[2][idx]
    if lhs[2].size() != rhs[2].size():
        return lhs[2].size() > rhs[2].size()
    return rhs[0] > lhs[0]
    

static func part1(data: String) -> String:
    return str(_quality(data)[1]) 
    

static func part2(data: String) -> String:
    var qualities: Array[int]
    var lines: PackedStringArray = ECodes.string_to_lines(data)
    for line: String in lines:
        if line.length() > 2:
            qualities.append(_quality(line)[1])
    assert(qualities.size() > 1, "Should have more than 1 _quality")
    qualities.sort()
    var answer: int = qualities.pop_back() - qualities.pop_front()
    return str(answer)


static func part3(data: String) -> String:
    var arr: Array[Variant] = []
    var sum: int = 0
    var lines: PackedStringArray = ECodes.string_to_lines(data)
    for line: String in lines:
        if line.length() > 2:
            arr.append(_quality(line))

    arr.sort_custom(_fishbone_sort)
    arr.reverse()
    for idx: int in range(arr.size()):
        sum += (idx +1) * arr[idx][0]
    
    return str(sum)
