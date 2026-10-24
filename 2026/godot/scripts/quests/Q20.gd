class_name Q20 extends RefCounted

const BIG_NUMBER: int = 1234567890

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


func rot120(lines: Array[String]) -> Array[String]:

	var stripped_lines: Array[String] = []
	var max_len: int = 0
	for line: String in lines:
		var s: String = line.strip_edges().strip_edges().replace(".", "").strip_edges()

		s = line.lstrip(".").rstrip(".")
		stripped_lines.append(s)
		if s.length() > max_len:
			max_len = s.length()
    

	for i: int in range(stripped_lines.size()):
		while stripped_lines[i].length() < max_len:
			stripped_lines[i] += "."
    

	var result: Array[String] = []
	for col: int in range(max_len):
		var row_chars: Array[String] = []
		for row: int in range(stripped_lines.size() - 1, -1, -1):  # reversed
			if col < stripped_lines[row].length():
				row_chars.append(stripped_lines[row][col])
			else:
				row_chars.append(".")
		result.append("".join(row_chars))
    

	if result.size() % 2 == 1:
		result.append(".".repeat(result[0].length()))
    

	var result2: Array[String] = []
	var pair_idx: int = 0
	while pair_idx < result.size():
		var row1: String = result[pair_idx]
		var row2: String = result[pair_idx + 1] if pair_idx + 1 < result.size() else ""
        
		var final_row: Array[String] = []
		var max_row_len: int = max(row1.length(), row2.length())
        
		for idx: int in range(max_row_len):
			var a: String = row1[idx] if idx < row1.length() else "."
			var b: String = row2[idx] if idx < row2.length() else "."
            
			if b != ".":
				final_row.append(b)
			if a != ".":
				final_row.append(a)
        
		result2.append("".join(final_row))
		pair_idx += 2
    

	for r: int in range(result2.size()):
		var row_str: String = result2[r].lstrip(".").rstrip(".")
		result2[r] = ".".repeat(r) + row_str + ".".repeat(r)
    
	return result2


func get_nei(r: int, c: int) -> Array[Array]:
	var neis: Array[Array] = [[r, c], [r, c + 1], [r, c - 1]]
    
	if c % 2 == r % 2:
		neis.append([r - 1, c])
	else:
		neis.append([r + 1, c])
    
	return neis


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
			costs[key] = BIG_NUMBER
    
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


func part3(data: String) -> String:
	var lines: PackedStringArray = data.split("\n")
    

	var start_r: int = -1
	var start_c: int = -1
	for r: int in range(lines.size()):
		for c: int in range(lines[r].length()):
			if lines[r][c] == 'S':
				start_r = r
				start_c = c
				break
		if start_r != -1:
			break
    
	var lines_array: Array[String] = []
	for line: String in lines:
		lines_array.append(line)
    

	var all_lines: Array[Array] = []
	all_lines.append(lines_array)
	all_lines.append(rot120(lines_array))
	all_lines.append(rot120(rot120(lines_array)))
    
	var nrows: int = lines_array.size()
	var ncols: int = lines_array[0].length()
    

	var q: Array[Array] = [[start_r, start_c]]
   

	var seen: Dictionary = {}
	var seen_key: String = str(start_r) + "," + str(start_c) + ",0"
	seen[seen_key] = true
    
	var jumps: int = 0
	var found: bool = false
    
	while q.size() > 0 and not found:
		var q_len: int = q.size()
        
		for _i: int in range(q_len):
			var pos: Array = q.pop_front()
			var r: int = pos[0]
			var c: int = pos[1]
            
			var current_lines: Array[String] = all_lines[jumps % 3]
			if current_lines[r][c] == 'E':
				found = true
				break
            
			var neighbors: Array[Array] = get_nei(r, c)
			for nei: Array in neighbors:
				var r2: int = nei[0]
				var c2: int = nei[1]
				var rot2: int = (jumps + 1) % 3
                
				var key: String = str(r2) + "," + str(c2) + "," + str(rot2)
				if seen.has(key):
					continue
				seen[key] = true
                
				if not (0 <= r2 and r2 < nrows and 0 <= c2 and c2 < ncols):
					continue
                
				var next_lines: Array[String] = all_lines[rot2]
				var cell: String = next_lines[r2][c2]
				if cell != 'E' and cell != 'S' and cell != 'T':
					continue
                
				q.append([r2, c2])
        
		if not found:
			jumps += 1
    
	return str(jumps)
