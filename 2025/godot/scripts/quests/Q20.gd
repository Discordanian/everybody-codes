class_name Q20 extends RefCounted



func adj(p: Array[int]) -> Array[Array]:
    var i: int = p[0]
    var j: int = p[1]
    var result: Array[Array] = []
    
    result.append([i, j - 1])
    result.append([i, j + 1])
    
    if j % 2 == 1: # ^
        result.append([i + 1, j - 1])
    else: # v
        result.append([i - 1, j + 1])
    
    return result

func part1(data: String) -> String:
    var lines: PackedStringArray = data.split("\n")
    
    # Strip trailing dots from each line
    var grid: Array[String] = []
    for l: String in lines:
        if l.is_empty():
            continue
        var stripped: String = l.rstrip(".").lstrip(".")
        grid.append(stripped)
    
    # Build grid dictionary using string keys
    var grid_dict: Dictionary = {} # Dictionary[String, String]
    for i: int in range(grid.size()):
        var row: String = grid[i]
        for j: int in range(row.length()):
            var cell: String = row[j]
            var key: String = str(i) + "," + str(j)
            grid_dict[key] = cell
    
    # Count adjacent T pairs
    var total: int = 0
    for key: String in grid_dict.keys():
        var cell: String = grid_dict[key]
        
        if cell == 'T':
            # Parse the key back to coordinates
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
    return str(data.length() + 123456)


func part3(data: String) -> String:
    return str(data.length())
