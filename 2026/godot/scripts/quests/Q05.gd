class_name Q05 extends RefCounted

# Cells that must be land or trees in the 5 by 5 stamp. Dots are omitted.
const STAMP: Array[Vector2i] = [
	Vector2i(-1, -2), Vector2i(0, -2), Vector2i(1, -2),
	Vector2i(-2, -1), Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1), Vector2i(2, -1),
	Vector2i(-2, 0), Vector2i(-1, 0), Vector2i(1, 0), Vector2i(2, 0),
	Vector2i(-2, 1), Vector2i(-1, 1), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1),
	Vector2i(-1, 2), Vector2i(0, 2), Vector2i(1, 2),
]

func part1(data: String) -> String:
	var grid: Array[Array] = _grid(data)
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	return str(_land(grid, size.y, size.x).size())


func part2(data: String) -> String:
	var grid: Array[Array] = _grid(data)
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	var land: Set = _land(grid, size.y, size.x)
	return str(_sand(land, size.y, size.x).size())


func part3(data: String) -> String:
	var grid: Array[Array] = _grid(data)
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	var cols: int = size.y
	var rows: int = size.x
	var land: Set = _land(grid, cols, rows)
	var sand: Set = _sand(land, cols, rows)
	var trees: Set = _stamp(land, sand)
	for _step: int in 2:
		trees = _grow(land, sand, trees)
	return str(trees.size())


func _grid(data: String) -> Array[Array]:
	return ECodes.string_to_2d_char_array(data.replace("\r", "").strip_edges())


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


func _sand(land: Set, cols: int, rows: int) -> Set:
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
	return sand


func _stamp(land: Set, sand: Set) -> Set:
	var cells: Array[Vector2i] = []
	for cell: Vector2i in land:
		if not sand.contains(cell):
			cells.append(cell)
	cells.sort_custom(func(left: Vector2i, right: Vector2i) -> bool:
		if left.y != right.y:
			return left.y < right.y
		return left.x < right.x
	)
	var trees: Set = Set.new()
	for cell: Vector2i in cells:
		if _stamp_fits(cell, land, sand):
			trees.add(cell)
	return trees


func _stamp_fits(cell: Vector2i, land: Set, sand: Set) -> bool:
	for offset: Vector2i in STAMP:
		var neighbor: Vector2i = cell + offset
		if not land.contains(neighbor) or sand.contains(neighbor):
			return false
	return true


func _grow(land: Set, sand: Set, trees: Set) -> Set:
	var added: Array[Vector2i] = []
	for cell: Vector2i in land:
		if sand.contains(cell) or trees.contains(cell):
			continue
		if _can_grow(sand, trees, cell):
			added.append(cell)
	for cell: Vector2i in added:
		trees.add(cell)
	return trees


func _can_grow(sand: Set, trees: Set, cell: Vector2i) -> bool:
	var nearby: int = 0
	for offset: Vector2i in ECodes.ALL_NEIGHBORS:
		var neighbor: Vector2i = cell + offset
		if sand.contains(neighbor):
			return false
		if trees.contains(neighbor):
			nearby += 1
	return nearby >= 4


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
