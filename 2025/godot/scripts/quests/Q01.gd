class_name Q01 extends RefCounted

static func _value_from_move(move: String) -> int:
    assert(move.length() > 1, "Move given was too short")
    
    var direction: String = move[0]
    var value_str: String = move.substr(1)
    var value: int = value_str.to_int()
    
    if direction == "L":
        return -value 
    return value       

static func part1(data: String) -> String:
    var d: PackedStringArray = ECodes.string_to_lines(data)
    if d.size() < 3:
        push_error(data)
    var names: PackedStringArray = d[0].split(",")
    var moves: PackedStringArray =  d[2].split(",")
    var pointer: int = 0
    
    var max_idx: int = names.size() - 1
    for move: String in moves:
        var v: int = _value_from_move(move)
        pointer = clamp(pointer + v, 0, max_idx)
        
    return names[pointer]
    

static func part2(data: String) -> String:
    var d: PackedStringArray = ECodes.string_to_lines(data)
    if d.size() < 3:
        push_error(data)
    var names: PackedStringArray = d[0].split(",")
    var moves: PackedStringArray =  d[2].split(",")
    var pointer: int = 0
    var max_idx: int = names.size() 
    
    for move: String in moves:
        var v: int = _value_from_move(move)
        pointer = AoCMath.euclidean_mod(pointer + v, max_idx)    
    return names[pointer]


static func part3(data: String) -> String:
    var d: PackedStringArray = ECodes.string_to_lines(data)
    var names: PackedStringArray = d[0].split(",")
    var moves: PackedStringArray = d[2].split(",")
    var max_idx: int = names.size()
    
    for move: String in moves:
        var v: int = _value_from_move(move)
        var idx: int = AoCMath.euclidean_mod(v, max_idx)
        if idx != 0:
            # Swap positions
            var temp: String = names[0]
            names[0] = names[idx]
            names[idx] = temp
        
    return names[0]
