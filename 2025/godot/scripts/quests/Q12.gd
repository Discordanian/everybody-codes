class_name Q12 extends RefCounted

static func in_grid(l: Vector2i, w: int, h: int) -> bool:
	var x_inbounds: bool = 0 <= l.x and l.x < w
	var y_inbounds: bool = 0 <= l.y and l.y < h
	return x_inbounds and y_inbounds

static func _flood_fill(grid: PackedStringArray, start: Vector2i) -> Set:
	var visited: Set = Set.new()
	var queue: Array = [start]
	var width: int = grid[0].length()
	var height: int = grid.size()    
	while queue.size() > 0:
		var coord: Vector2i = queue.pop_front()
        
		if visited.contains(coord):
			continue
        
		var current_char: String = grid[coord.y][coord.x]
		visited.add(coord)
        
		var directions: Array = [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1)]
		for dir: Vector2i in directions:
			var new_coord: Vector2i = coord + dir
            

			if visited.contains(new_coord):
				continue
            

			if new_coord.x >= 0 and new_coord.x < width and new_coord.y >= 0 and new_coord.y < height:
				var neighbor_char: String = grid[new_coord.y][new_coord.x]
				if neighbor_char <= current_char:
					queue.append(new_coord)
    
	return visited

static func _find_max_coordinate(grid: PackedStringArray, coords: Set) -> Vector2i:
	var max_coord: Vector2i = Vector2i(-1, -1)
	var max_value: String = ""
    
	for coord: Variant in coords.get_as_array():
		var v: Vector2i = coord as Vector2i
		var value: String = grid[v.y][v.x]
		if max_value == "" or value > max_value:
			max_value = value
			max_coord = v
    
	return max_coord

static func _find_region(grid: PackedStringArray, removed: Set) -> Dictionary:
	var width: int = grid[0].length()
	var height: int = grid.size()
	var available: Set = Set.new()
	for i: int in range(width):
		for j: int in range(height):
			var coord: Vector2i = Vector2i(i, j)
			if not removed.contains(coord):
				available.add(coord)
    
	var max_size: int = 0
	var max_region: Set = Set.new()
    

	while not available.is_empty():

		var max_coord: Vector2i = _find_max_coordinate(grid, available)
		available.remove(max_coord)
        
		# Flood fill from this coordinate
		var region: Set = _flood_fill(grid, max_coord)
        

		for coord: Variant in region.get_as_array():
			available.remove(coord)
        

		var valid_size: int = 0
		for coord: Variant in region.get_as_array():
			if not removed.contains(coord):
				valid_size += 1
        

		if valid_size > max_size:
			max_size = valid_size
			max_region = region
    
	return {"size": max_size, "region": max_region}

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
	var grid: PackedStringArray = ECodes.string_to_lines(data.strip_edges())
	var w: int = grid[0].length()
	var h: int = grid.size()
	var burned: Set = Set.new()
	var dirs: Array[Vector2i] = [ Vector2i(-1,0), Vector2i(1,0), Vector2i(0,-1), Vector2i(0,1)]
	var q: Array[Vector2i] = [Vector2i(0,0), Vector2i(w-1, h-1)]
    
	for loc: Vector2i in q:
		var val: String = grid[loc.y][loc.x]
		if burned.contains(loc):
			continue
		burned.add(loc)
		for d: Vector2i in dirs:
			var new_loc: Vector2i = loc + d
			if not burned.contains(new_loc):
				if in_grid(new_loc, w, h) and int(grid[new_loc.y][new_loc.x]) <= int(val):
					q.append(new_loc) 
	return str(burned.size())





static func part3(data: String) -> String:
	var grid: PackedStringArray = ECodes.string_to_lines(data.strip_edges())

	var result1: Dictionary = _find_region(grid, Set.new())
	var s1: Set = result1["region"]  

	var result2: Dictionary = _find_region(grid, s1)
	var s2: Set = result2["region"]

	var combined: Set = s1.union(s2)
	var result3: Dictionary = _find_region(grid, combined)
	var s3: Set = result3["region"]
    
	# Return total unique coordinates
	var total: Set = s1.union(s2).union(s3)
	return str(total.size())
