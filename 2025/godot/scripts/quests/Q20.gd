class_name Q20 extends RefCounted



func adj(p: Array[int]) -> Array[Array]:
    var i: int = p[0]
    var j: int = p[1]
    var result: Array[Array] = []
    
    result.append([i, j - 1])
    result.append([i, j + 1])
    
    if j % 2 == 1: # point up
        result.append([i + 1, j - 1])
    else: # point down
        result.append([i - 1, j + 1])
    
    return result

func part1(data: String) -> String:
    var lines: PackedStringArray = data.split("\n")
    

    var grid: Array[String] = []
    for l: String in lines:
        if l.is_empty():
            continue
        var stripped: String = l.rstrip(".").lstrip(".")
        grid.append(stripped)
    

    var grid_dict: Dictionary = {} # Dictionary[String, String]
    for i: int in range(grid.size()):
        var row: String = grid[i]
        for j: int in range(row.length()):
            var cell: String = row[j]
            var key: String = str(i) + "," + str(j)
            grid_dict[key] = cell
    

    var total: int = 0
    for key: String in grid_dict.keys():
        var cell: String = grid_dict[key]
        
        if cell == 'T':

            var parts: PackedStringArray = key.split(",")
            var i: int = int(parts[0])
            var j: int = int(parts[1])
            
            var adjacent: Array[Array] = adj([i, j])
            for a: Array in adjacent:
                var a_key: String = str(a[0]) + "," + str(a[1])
                if grid_dict.has(a_key) and grid_dict[a_key] == 'T':
                    total += 1
    @warning_ignore("integer_division")
    return str(total / 2)


func part2(data: String) -> String:
    var lines: PackedStringArray = data.split("\n")
    

    var grid: Array[String] = []
    for l: String in lines:
        if l.is_empty():
            continue
        var stripped: String = l.lstrip(".").rstrip(".")
        grid.append(stripped)
    

    var grid_dict: Dictionary = {} # Dictionary[String, String]
    var start: String = ""
    var end: String = ""
    
    for i: int in range(grid.size()):
        var row: String = grid[i]
        for j: int in range(row.length()):
            var cell: String = row[j]
            var key: String = str(i) + "," + str(j)
            
            if cell == 'S':
                start = key
                cell = 'T'
            elif cell == 'E':
                end = key
                cell = 'T'
            
            grid_dict[key] = cell
    

    var costs: Dictionary = {} # Dictionary[String, int]
    for key: String in grid_dict.keys():
        var cell: String = grid_dict[key]
        if cell == 'T':
            costs[key] = 1000000000
    
    costs[start] = 0
    

    var q: Array[String] = [start]
    var in_q: Dictionary = {} # Dictionary[String, bool] - using as a set
    in_q[start] = true
    
    while q.size() > 0:
        var p: String = q.pop_front()
        in_q.erase(p)
        
        var cost: int = costs[p] + 1
        

        var parts: PackedStringArray = p.split(",")
        var i: int = int(parts[0])
        var j: int = int(parts[1])
        
        var adjacent: Array[Array] = adj([i, j])
        for a: Array in adjacent:
            var a_key: String = str(a[0]) + "," + str(a[1])
            
            if costs.has(a_key) and cost < costs[a_key]:
                costs[a_key] = cost
                if not in_q.has(a_key):
                    q.append(a_key)
                    in_q[a_key] = true
    
    return str(costs[end])


func rotate_coord(p: String, rotation_grid: Dictionary) -> String:
    if rotation_grid.has(p):
        return rotation_grid[p]
    return p

func adjr(p: String, rotation_grid: Dictionary) -> Array[String]:
    var result: Array[String] = []
    
    # in place
    result.append(rotate_coord(p, rotation_grid))
    
    # Parse position
    var parts: PackedStringArray = p.split(",")
    var i: int = int(parts[0])
    var j: int = int(parts[1])
    
    var adjacent: Array[Array] = adj([i, j])
    for a: Array in adjacent:
        var a_key: String = str(a[0]) + "," + str(a[1])
        result.append(rotate_coord(a_key, rotation_grid))
    
    return result

func part3(data: String) -> String:
    var lines: PackedStringArray = data.split("\n")
    
    # Strip dots from both ends of each line
    var grid: Array[String] = []
    for l: String in lines:
        if l.is_empty():
            continue
        var stripped: String = l.lstrip(".").rstrip(".")
        grid.append(stripped)
    
    # Build grid dictionary and find start/end positions
    var grid_dict: Dictionary = {} # Dictionary[String, String]
    var start: String = ""
    var end: String = ""
    
    for i: int in range(grid.size()):
        var row: String = grid[i]
        for j: int in range(row.length()):
            var cell: String = row[j]
            var key: String = str(i) + "," + str(j)
            
            if cell == 'S':
                start = key
                cell = 'T'
            elif cell == 'E':
                end = key
                cell = 'T'
            
            grid_dict[key] = cell
    
    # Build temp_rotation_grid - create coordinate grid
    var temp_rotation_grid: Array[Array] = []
    for i: int in range(grid.size()):
        var row: String = grid[i]
        var coord_row: Array[String] = []
        for j: int in range(row.length()):
            coord_row.append(str(i) + "," + str(j))
        temp_rotation_grid.append(coord_row)
    
    # Split rows into even and odd columns: [row[e::2] for row in temp_rotation_grid for e in (0,1)]
    var split_rows: Array[Array] = []
    for row: Array in temp_rotation_grid:
        # Even indices (0, 2, 4, ...)
        var even_row: Array[String] = []
        for idx: int in range(0, row.size(), 2):
            even_row.append(row[idx])
        split_rows.append(even_row)
        
        # Odd indices (1, 3, 5, ...)
        var odd_row: Array[String] = []
        for idx: int in range(1, row.size(), 2):
            odd_row.append(row[idx])
        split_rows.append(odd_row)
    
    # Reverse
    split_rows.reverse()
    
    # Transpose with zip_longest behavior (filter out nulls)
    var max_len: int = 0
    for row: Array in split_rows:
        if row.size() > max_len:
            max_len = row.size()
    
    var transposed: Array[Array] = []
    for col_idx: int in range(max_len):
        var col: Array[String] = []
        for row: Array in split_rows:
            if col_idx < row.size():
                var val: String = row[col_idx]
                if not val.is_empty():
                    col.append(val)
        if col.size() > 0:
            transposed.append(col)
    
    # Build rotation_grid dictionary
    var rotation_grid: Dictionary = {} # Dictionary[String, String]
    for i: int in range(transposed.size()):
        var row: Array = transposed[i]
        for j: int in range(row.size()):
            var d: String = row[j]
            var key: String = str(i) + "," + str(j)
            rotation_grid[d] = key
    
    # Initialize costs dictionary
    var costs: Dictionary = {} # Dictionary[String, int]
    for key: String in grid_dict.keys():
        var cell: String = grid_dict[key]
        if cell == 'T':
            costs[key] = 1000000000
    
    costs[start] = 0
    
    # BFS with queue
    var q: Array[String] = [start]
    var in_q: Dictionary = {} # Dictionary[String, bool] - using as a set
    in_q[start] = true
    
    while q.size() > 0:
        var p: String = q.pop_front()
        in_q.erase(p)
        
        var cost: int = costs[p] + 1
        
        var adjacent_rotated: Array[String] = adjr(p, rotation_grid)
        for a_key: String in adjacent_rotated:
            if costs.has(a_key) and cost < costs[a_key]:
                costs[a_key] = cost
                if not in_q.has(a_key):
                    q.append(a_key)
                    in_q[a_key] = true
    
    return str(costs[end])
