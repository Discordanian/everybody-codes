class_name Q17 extends RefCounted

var grid: Array[Array]
var volcano: Vector2i
var start: Vector2i
var radius: int

func populate_grid(data:String) -> void:
    grid = [] # Make sure grid is empty
    var lines: PackedStringArray = ECodes.string_to_lines(data.strip_edges())

    for y: int in lines.size():
        var row: Array[int] = []
        for x: int in range(lines[0].length()):
            if lines[y][x] == "@":
                volcano = Vector2i(x,y)
                row.append(0)
            else:
                row.append(int(lines[y][x]))
        grid.append(row)
    

func find_volcano() -> Vector2i:
    for y: int in grid.size():
        for x: int in grid[0].size():
            if grid[y][x] == 0:
                return Vector2i(x,y)
    push_error("Unable to find volcano")
    return Vector2i(-1,-1)

func within_distance(x: int, y: int) -> bool:
    # (Xv - Xc) * (Xv - Xc) + (Yv - Yc) * (Yv - Yc) <= R * R
    assert(radius > 0)
    return (volcano.x - x) * (volcano.x - x) + (volcano.y - y) * (volcano.y - y) <= (radius * radius)

func sum_at_distance(r: int) -> int:
    var retval: int = 0
    for y: int in range(grid.size()):
        for x: int in range(grid[0].size()):
            if (volcano.x - x) * (volcano.x - x) + (volcano.y - y) * (volcano.y - y) == (r * r):
                retval += grid[y][x]                
    return retval    

func part1(data: String) -> String:
    populate_grid(data)
    radius = 10
    print(volcano)
    print(grid[0])
    var retval: int = 0
    for y: int in range(grid.size()):
        for x: int in range(grid[0].size()):
            if within_distance(x,y):
                retval += grid[y][x]          
    return str(retval)


func part2(data: String) -> String:
    populate_grid(data)
    @warning_ignore("integer_division")
    var border_radius: int = grid[0].size()/2
    var max_sum: int = 0
    var max_r: int = 0
    for r: int in range(1,border_radius):
        var s: int = sum_at_distance(r)
        if s > max_sum:
            max_sum = s
            max_r = r
            print("New r ",r," New max sum ", max_sum)
       
    return str(max_sum * max_r)


func part3(data: String) -> String:
    return str(data.length())
