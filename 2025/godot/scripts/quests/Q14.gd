class_name Q14 extends RefCounted

# Assume that grid isn't needed in the return
# @param active Set the set of active nodes
# @param grid Set just a set of every node in the grid
static func _round(active: Set, grid: Set) -> Set:
    var diags: Array[Vector2i] = [ Vector2i(1,1), Vector2i(-1,-1), Vector2i(1,-1), Vector2i(-1,1)]
    var next_active: Set = Set.new()
    var diag_count: int = 0
    for v: Vector2i in grid:
        diag_count = 0
        for d: Vector2i in diags:
            if active.contains(v + d):
                diag_count += 1
        if active.contains(v) and diag_count % 2 == 1:
            next_active.add(v)
        if not active.contains(v) and diag_count % 2 == 0:
            next_active.add(v)
    return next_active
                 
        
        
        

static func part1(data: String) -> String:
    var lines: PackedStringArray = ECodes.string_to_lines(data.strip_edges())
    var grid: Set = Set.new()
    var active: Set = Set.new()
    for y: int in range(lines.size()):
        for x: int in range(lines[y].length()):
            var v: Vector2i = Vector2i(x,y)
            grid.add(v)
            if lines[y][x] == "#":
                active.add(v)
    var sum: int = 0            
    for _r: int in range(10):
        active = _round(active, grid)
        sum += active.size()
    
    
    return str(sum)
    

static func part2(data: String) -> String:
    var lines: PackedStringArray = ECodes.string_to_lines(data.strip_edges())
    var grid: Set = Set.new()
    var active: Set = Set.new()
    for y: int in range(lines.size()):
        for x: int in range(lines[y].length()):
            var v: Vector2i = Vector2i(x,y)
            grid.add(v)
            if lines[y][x] == "#":
                active.add(v)
    var sum: int = 0            
    for _r: int in range(2025):
        active = _round(active, grid)
        sum += active.size()
    
    
    return str(sum)


static func part3(data: String) -> String:
    return data
