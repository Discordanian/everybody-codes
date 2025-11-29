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
        
        # Parse position
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


func part3(data: String) -> String:
    return str(data.length())
