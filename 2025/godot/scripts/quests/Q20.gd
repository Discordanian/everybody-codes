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
    # Python: temp_rotation_grid = [[(i,j) for j, cell in enumerate(row)] for i,row in enumerate(grid)]
    var temp_rotation_grid: Array[Array] = []
    
    for i: int in range(grid.size()):
        var row: String = grid[i]
        var row_coords: Array[Array] = []
        for j: int in range(row.length()):
            row_coords.append([i, j])
        temp_rotation_grid.append(row_coords)
    
    # Python: temp_rotation_grid = [row[e::2] for row in temp_rotation_grid for e in (0,1)]
    # This means: for each row, create row[0::2] (even indices) and row[1::2] (odd indices)
    # The result is a flat list: [row0_even, row0_odd, row1_even, row1_odd, ...]
    var split_rows: Array[Array] = []
    for row: Array in temp_rotation_grid:
        # row[0::2] - elements at indices 0, 2, 4, ...
        var even_row: Array[Array] = []
        for idx: int in range(0, row.size(), 2):
            even_row.append(row[idx])
        split_rows.append(even_row)
        
        # row[1::2] - elements at indices 1, 3, 5, ...
        var odd_row: Array[Array] = []
        for idx: int in range(1, row.size(), 2):
            odd_row.append(row[idx])
        split_rows.append(odd_row)
    
    # Python: temp_rotation_grid.reverse()
    split_rows.reverse()
    
    # Python: temp_rotation_grid = [list(filter(None,r)) for r in zip_longest(*temp_rotation_grid)]
    # zip_longest transposes the matrix, filling with None where needed
    # filter(None, r) removes None values
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
    
    # Python: rotation_grid = {(i,j):d for i,row in enumerate(temp_rotation_grid) for j,d in enumerate(row)}
    # KEY is (i,j) - position in the transposed grid
    # VALUE is d - the original coordinate that's stored at transposed[i][j]
    # So rotation_grid maps: NEW position -> ORIGINAL position
    var rotation_grid: Dictionary = {}
    for new_i: int in range(transposed.size()):
        var row: Array = transposed[new_i]
        for new_j: int in range(row.size()):
            var original_coord: Array = row[new_j]  # This is [i, j] from original grid
            var new_key: String = str(new_i) + "," + str(new_j)
            var original_key: String = str(original_coord[0]) + "," + str(original_coord[1])
            rotation_grid[new_key] = original_key  # NEW -> ORIGINAL
    
    return rotation_grid


func _rotate_coord(p: String, inverse_rotation: Dictionary) -> String:
    if inverse_rotation.has(p):
        return inverse_rotation[p]
    return ""


func _adjr(p: String, inverse_rotation: Dictionary) -> Array[String]:
    # Python: def adjr(p):
    #     yield rotate_coord(p)  # in place - rotate p itself
    #     for a in adj(p):       # for each adjacent of p
    #         yield rotate_coord(a)  # rotate that adjacent
    # 
    # p is in ORIGINAL coordinates
    # Returns coordinates in ROTATED space
    var result: Array[String] = []
    
    # First: rotate p itself (the "in place" rotation)
    var rotated_p: String = _rotate_coord(p, inverse_rotation)
    if not rotated_p.is_empty():
        result.append(rotated_p)
    
    # Then: get adjacents of p in original space and rotate each one
    var parts: PackedStringArray = p.split(",")
    var i: int = int(parts[0])
    var j: int = int(parts[1])
    
    var adjacent: Array[Array] = adj([i, j])
    for a: Array in adjacent:
        var a_key: String = str(a[0]) + "," + str(a[1])
        var rotated_a: String = _rotate_coord(a_key, inverse_rotation)
        if not rotated_a.is_empty():
            result.append(rotated_a)
    
    return result


func part3(data: String) -> String:
    var lines: PackedStringArray = data.split("\n")
    
    var grid: Array[String] = []
    for l: String in lines:
        if l.is_empty():
            continue
        var stripped: String = l.lstrip(".").rstrip(".")
        grid.append(stripped)
    
    # Build grid dictionary in ORIGINAL coordinates
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
    
    # Build rotation grid (new position -> original position)
    var rotation_grid: Dictionary = _build_rotation_grid(grid)
    
    print("Rotation grid size: ", rotation_grid.size())
    
    # Build inverse: original position -> new position (what we actually need for rotate_coord)
    var inverse_rotation: Dictionary = {}
    var duplicate_count: int = 0
    for new_pos: String in rotation_grid.keys():
        var orig_pos: String = rotation_grid[new_pos]
        if inverse_rotation.has(orig_pos):
            duplicate_count += 1
            # Multiple new positions map to same original - keep the last one
        inverse_rotation[orig_pos] = new_pos
    
    print("Inverse rotation size: ", inverse_rotation.size())
    if duplicate_count > 0:
        print("WARNING: ", duplicate_count, " duplicate mappings found (multiple new positions -> same original)")
    
    # Check: are there original positions with no rotation?
    var no_rotation: int = 0
    for orig: String in grid_dict.keys():
        if not inverse_rotation.has(orig):
            no_rotation += 1
    if no_rotation > 0:
        print("WARNING: ", no_rotation, " original positions have no rotation mapping")
    
    # Debug: check a few mappings
    print("Sample rotation mappings:")
    var sample_count: int = 0
    for orig: String in rotation_grid.keys():
        if sample_count < 5:
            var rot: String = rotation_grid[orig]
            var orig_cell: String = grid_dict.get(orig, "?")
            var rot_cell: String = grid_dict.get(rot, "?")
            print("  ", orig, "(", orig_cell, ") -> ", rot, "(", rot_cell, ")")
            sample_count += 1
    
    # Check if start position maps anywhere
    if rotation_grid.has(start):
        print("Start ", start, " rotates to: ", rotation_grid[start])
    
    # Critical check: After rotation, do T cells map to T cells?
    var t_to_t: int = 0
    var t_to_other: int = 0
    for orig: String in grid_dict.keys():
        if grid_dict[orig] == 'T' and rotation_grid.has(orig):
            var rotated: String = rotation_grid[orig]
            if grid_dict.has(rotated) and grid_dict[rotated] == 'T':
                t_to_t += 1
            else:
                t_to_other += 1
    print("T cells that rotate to T cells: ", t_to_t)
    print("T cells that rotate to non-T cells: ", t_to_other)
    
    # Check: do any rotated coords exist in the original grid?
    var overlap_count: int = 0
    for orig: String in rotation_grid.keys():
        var rotated: String = rotation_grid[orig]
        if grid_dict.has(rotated):
            overlap_count += 1
    print("Rotated coords that exist in original grid: ", overlap_count, " out of ", rotation_grid.size())
    
    # Build reverse rotation grid (rotated -> original)
    # This tells us: for a given rotated position, which original position does it come from?
    var reverse_rotation: Dictionary = {}
    for orig_key: String in rotation_grid.keys():
        var rot_key: String = rotation_grid[orig_key]
        reverse_rotation[rot_key] = orig_key
    
    # Now we need to understand: rotation_grid maps original->rotated
    # But multiple original positions might map to the same rotated position
    # And the rotated space might be smaller than the original space
    
    # The Python code does: for a in adjr(p): if a in costs
    # So 'a' (rotated coord) must be a KEY in costs
    # But costs is built from grid_dict keys (original coords)
    # This means: rotated coordinates that are returned must ALSO be original coordinates!
    
    # I think the rotation creates a wraparound effect where some original positions
    # "connect" to other original positions through the rotation mapping
    
    # Let's check: do rotated coordinates ever match original coordinates?
    # They should, because the rotation is mapping the grid onto itself in a different arrangement
    
    # Initialize costs in ORIGINAL coordinate space
    var costs: Dictionary = {} # Dictionary[String, int]
    for key: String in grid_dict.keys():
        var cell: String = grid_dict[key]
        if cell == 'T':
            costs[key] = 10000000000
    
    costs[start] = 0
    
    # BFS in ORIGINAL space
    var q: Array[String] = [start]
    var in_q: Dictionary = {} # Dictionary[String, bool]
    in_q[start] = true
    
    var visited_count: int = 0
    
    while q.size() > 0:
        var p: String = q.pop_front()
        in_q.erase(p)
        visited_count += 1
        
        var cost: int = costs[p] + 1
        
        # Get adjacent coordinates through rotation
        # These are in ROTATED space but should correspond to positions in ORIGINAL space
        var adjacent: Array[String] = _adjr(p, inverse_rotation)
        
        for a: String in adjacent:
            # 'a' is a rotated coordinate
            # Check if this rotated coordinate exists as an original coordinate in our costs
            if costs.has(a) and cost < costs[a]:
                costs[a] = cost
                if not in_q.has(a):
                    q.append(a)
                    in_q[a] = true
    
    print("Visited ", visited_count, " positions out of ", costs.size(), " total T cells")
    print("End reachable: ", costs[end] < 10000000000)
    
    # Check which positions are unreachable
    var unreachable: Array[String] = []
    for key: String in costs.keys():
        if costs[key] == 10000000000:
            unreachable.append(key)
    print("Unreachable positions (", unreachable.size(), "): ", unreachable)
    print("End position: ", end, " in unreachable? ", unreachable.has(end))
    
    return str(costs[end])
