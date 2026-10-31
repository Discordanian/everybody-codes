class_name Q05 extends RefCounted

func part1(data: String) -> String:
	var grid: Array[Array] = _grid(data)
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	return str(_land(grid, size.y, size.x).size())


func part2(data: String) -> String:
	var grid: Array[Array] = _grid(data)
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	var cols: int = size.y
	var rows: int = size.x
	var land: Set = _land(grid, cols, rows)
	var sand: Set = _coastline(land, cols, rows)
	var growing: bool = true
	while growing:
		var added: Array[Vector2i] = []
		for cell: Vector2i in land:
			if sand.contains(cell):
				continue
			if _sand_support(sand, cell) >= 5:
				added.append(cell)
		growing = not added.is_empty()
		for cell: Vector2i in added:
			sand.add(cell)
	return str(sand.size())


func part3(data: String) -> String:
	return str(data.length())


func _grid(data: String) -> Array[Array]:
	return ECodes.string_to_2d_char_array(data.replace("\r", "").strip_edges())


# Seed the centre cell, then attach any frontier cell with at least five
# neighbours that are already land or dark on the original map.
func _land(grid: Array[Array], cols: int, rows: int) -> Set:
	var land: Set = Set.new()
	@warning_ignore("integer_division")
	land.add(Vector2i(cols / 2, rows / 2))
	var added: bool = true
	while added:
		added = false
		for cell: Vector2i in _frontier(land, cols, rows):
			if _support(grid, land, cell, cols, rows) >= 5:
				land.add(cell)
				added = true
	return land


# Land touching water, including past the map edge, is the first sand.
func _coastline(land: Set, cols: int, rows: int) -> Set:
	var sand: Set = Set.new()
	for cell: Vector2i in land:
		if _touches_water(land, cell, cols, rows):
			sand.add(cell)
	return sand


func _touches_water(land: Set, cell: Vector2i, cols: int, rows: int) -> bool:
	for offset: Vector2i in ECodes.ALL_NEIGHBORS:
		var neighbor: Vector2i = cell + offset
		if not _inside(neighbor, cols, rows) or not land.contains(neighbor):
			return true
	return false


func _sand_support(sand: Set, cell: Vector2i) -> int:
	var count: int = 0
	for offset: Vector2i in ECodes.ALL_NEIGHBORS:
		if sand.contains(cell + offset):
			count += 1
	return count


func _frontier(land: Set, cols: int, rows: int) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	var seen: Set = Set.new()
	for cell: Vector2i in land:
		for offset: Vector2i in ECodes.ALL_NEIGHBORS:
			var neighbor: Vector2i = cell + offset
			if not _inside(neighbor, cols, rows) or land.contains(neighbor) or seen.contains(neighbor):
				continue
			seen.add(neighbor)
			cells.append(neighbor)
	return cells


func _support(grid: Array[Array], land: Set, cell: Vector2i, cols: int, rows: int) -> int:
	var count: int = 0
	for offset: Vector2i in ECodes.ALL_NEIGHBORS:
		var neighbor: Vector2i = cell + offset
		if not _inside(neighbor, cols, rows):
			continue
		if land.contains(neighbor) or grid[neighbor.y][neighbor.x] == "1":
			count += 1
	return count


func _inside(cell: Vector2i, cols: int, rows: int) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < cols and cell.y < rows
