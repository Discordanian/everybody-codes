class_name Q12 extends RefCounted

static func in_grid(l: Vector2i, w: int, h: int) -> bool:
    var x_inbounds: bool = 0 <= l.x and l.x < w
    var y_inbounds: bool = 0 <= l.y and l.y < h
    return x_inbounds and y_inbounds

static func part1(data: String) -> String:
    var grid: PackedStringArray = ECodes.string_to_lines(data.strip_edges())
    var w: int = grid[0].length()
    var h: int = grid.size()
    var burned: Set = Set.new()
    var dirs: Array[Vector2i] = [ Vector2i(-1,0), Vector2i(1,0), Vector2i(0,-1), Vector2i(0,1)]
    var q: Array[Array] = [[Vector2i(0,0), grid[0][0]]]
    
    for v: Variant in q:
        var loc: Vector2i = v[0]
        var val: String = v[1]
        if burned.contains(loc):
            continue
        burned.add(loc)
        for d: Vector2i in dirs:
            var new_loc: Vector2i = loc + d
            if not burned.contains(new_loc):
                if in_grid(new_loc, w, h) and int(grid[new_loc.y][new_loc.x]) <= int(val):
                    q.append([new_loc, grid[new_loc.y][new_loc.x]])    
        
    
    return str(burned.size())
    

static func part2(data: String) -> String:
    return data


static func part3(data: String) -> String:
    return data
