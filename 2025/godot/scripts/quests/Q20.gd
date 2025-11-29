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


func _build_rotation_grid(grid: Array[String]) -> Dictionary:
    # Build coordinate grid
    var temp_rotation_grid: Array[Array] = []
    for i: int in range(grid.size()):
        var row: String = grid[i]
        var row_coords: Array[Array] = []
        for j: int in range(row.length()):
            row_coords.append([i, j])
        temp_rotation_grid.append(row_coords)
    
    # Split rows: even indices, then odd indices
    var split_rows: Array[Array] = []
    for row: Array in temp_rotation_grid:
        var even_row: Array[Array] = []
        for idx: int in range(0, row.size(), 2):
            even_row.append(row[idx])
        split_rows.append(even_row)
        
        var odd_row: Array[Array] = []
        for idx: int in range(1, row.size(), 2):
            odd_row.append(row[idx])
        split_rows.append(odd_row)
    
    # Reverse
    split_rows.reverse()
    
    # Transpose
    var max_len: int = 0
    for row: Array in split_rows:
        if row.size() > max_len:
            max_len = row.size()
    
    var transposed: Array[Array] = []
    for col_idx: int in range(max_len):
        var column: Array[Array] = []
        for row: Array in split_rows:
            if col_idx < row.size():
                column.append(row[col_idx])
        if column.size() > 0:
            transposed.append(column)
    
    # new_position -> original_position
    var rotation_grid: Dictionary = {}
    for new_i: int in range(transposed.size()):
        var row: Array = transposed[new_i]
        for new_j: int in range(row.size()):
            var original_coord: Array = row[new_j]
            var new_key: String = str(new_i) + "," + str(new_j)
            var original_key: String = str(original_coord[0]) + "," + str(original_coord[1])
            rotation_grid[new_key] = original_key
    
    return rotation_grid


func part3(data: String) -> String:
    var lines: PackedStringArray = data.split("\n")
    
    var grid: Array[String] = []
    for l: String in lines:
        if l.is_empty():
            continue
        var stripped: String = l.lstrip(".").rstrip(".")
        grid.append(stripped)
    
    # Build grid dictionary
    var grid_dict: Dictionary = {}
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
    

    var rotation_grid: Dictionary = _build_rotation_grid(grid)
    

    var inverse_rotation: Dictionary = {}
    for new_pos: String in rotation_grid.keys():
        var orig_pos: String = rotation_grid[new_pos]
        inverse_rotation[orig_pos] = new_pos
    

    print("Start: ", start)
    if inverse_rotation.has(start):
        print("  Start rotates to: ", inverse_rotation[start])
    
    var parts_s: PackedStringArray = start.split(",")
    var si: int = int(parts_s[0])
    var sj: int = int(parts_s[1])
    var start_neighbors: Array[Array] = adj([si, sj])
    print("Start neighbors in original space:")
    for sn: Array in start_neighbors:
        var sn_key: String = str(sn[0]) + "," + str(sn[1])
        var sn_cell: String = grid_dict.get(sn_key, "?")
        var sn_rot: String = inverse_rotation.get(sn_key, "none")
        print("  ", sn_key, " (", sn_cell, ") rotates to ", sn_rot)
    
    print("End: ", end)
    if inverse_rotation.has(end):
        print("  End rotates to: ", inverse_rotation[end])
    
    var parts_e: PackedStringArray = end.split(",")
    var ei: int = int(parts_e[0])
    var ej: int = int(parts_e[1])
    var end_neighbors: Array[Array] = adj([ei, ej])
    print("End neighbors in original space:")
    for en: Array in end_neighbors:
        var en_key: String = str(en[0]) + "," + str(en[1])
        var en_cell: String = grid_dict.get(en_key, "?")
        var en_rot: String = inverse_rotation.get(en_key, "none")
        print("  ", en_key, " (", en_cell, ") rotates to ", en_rot)
    

    print("\nPosition 3,6 analysis:")
    print("  Original grid[3,6] = ", grid_dict.get("3,6", "?"))
    print("  rotation_grid['3,6'] (what original coord is at rotated position 3,6) = ", rotation_grid.get("3,6", "?"))
    print("  inverse_rotation['3,6'] (where does original 3,6 rotate to) = ", inverse_rotation.get("3,6", "?"))
    

    var end_rotates_to: String = inverse_rotation.get("3,6", "")
    print("  End (original 3,6) rotates to: ", end_rotates_to)
    

    if not end_rotates_to.is_empty():
        var orig_at_rot_end: String = rotation_grid.get(end_rotates_to, "")
        print("  At rotated position ", end_rotates_to, ", the original coord is: ", orig_at_rot_end)
    

    var costs: Dictionary = {}
    for key: String in grid_dict.keys():
        var cell: String = grid_dict[key]
        if cell == 'T':
            costs[key] = 10000000000
    
    costs[start] = 0
    

    var q: Array[String] = [start]
    var in_q: Dictionary = {}
    in_q[start] = true
    
    var iterations: int = 0
    
    while q.size() > 0:
        var p: String = q.pop_front()
        in_q.erase(p)
        
        var cost: int = costs[p] + 1
        
        var adjacents: Array[String] = []

        if inverse_rotation.has(p):
            adjacents.append(inverse_rotation[p])
        

        var parts: PackedStringArray = p.split(",")
        var i: int = int(parts[0])
        var j: int = int(parts[1])
        var neighbors: Array[Array] = adj([i, j])
        for n: Array in neighbors:
            var n_key: String = str(n[0]) + "," + str(n[1])
            if inverse_rotation.has(n_key):
                adjacents.append(inverse_rotation[n_key])
        
        if iterations == 0:
            print("First iteration: p=", p, " adjacents=", adjacents)
            for a_test: String in adjacents:
                print("  ", a_test, " in costs? ", costs.has(a_test), " cost would be ", cost)
        
        for a: String in adjacents:
            if costs.has(a) and cost < costs[a]:
                costs[a] = cost
                if not in_q.has(a):
                    q.append(a)
                    in_q[a] = true
        
        iterations += 1
    
    print("Total iterations: ", iterations)
    print("Costs at end: ", costs[end])
    
    var rot_start: String = inverse_rotation.get(start, "")
    if not rot_start.is_empty():
        print("Rotated start ", rot_start, " has cost: ", costs.get(rot_start, -1))
        var orig_at_rot_start: String = rotation_grid.get(rot_start, "")
        print("  Original position at rotated start: ", orig_at_rot_start, " cell: ", grid_dict.get(orig_at_rot_start, "?"))
    

    print("Normal (non-rotated) path from start to its rotated position:")
    if not rot_start.is_empty() and costs.has(rot_start):
        print("  Cost to reach ", rot_start, " = ", costs[rot_start])
    
    return str(costs[end])
