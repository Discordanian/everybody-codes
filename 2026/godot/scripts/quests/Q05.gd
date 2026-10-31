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
	return str(_land(grid, _bounds(grid)).size())


func part2(data: String) -> String:
	var grid: Array[Array] = _grid(data)
	var bounds: Vector2i = _bounds(grid)
	return str(_sand(_land(grid, bounds), bounds).size())


func part3(data: String) -> String:
	var grid: Array[Array] = _grid(data)
	var bounds: Vector2i = _bounds(grid)
	var land: Set = _land(grid, bounds)
	var sand: Set = _sand(land, bounds)
	var trees: Set = _stamp(land, sand)
	_grow(land, sand, trees)
	_grow(land, sand, trees)
	return str(trees.size())


func _grid(data: String) -> Array[Array]:
	return ECodes.string_to_2d_char_array(data.replace("\r", "").strip_edges())


# x is the column count and y is the row count, matching cell coordinates.
func _bounds(grid: Array[Array]) -> Vector2i:
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	return Vector2i(size.y, size.x)


func _land(grid: Array[Array], bounds: Vector2i) -> Set:
	var land: Set = Set.new()
	@warning_ignore("integer_division")
	land.add(Vector2i(bounds.x / 2, bounds.y / 2))
	var growing: bool = true
	while growing:
		var added: Array[Vector2i] = []
		for cell: Vector2i in _frontier(land, bounds):
			if _support(grid, land, cell, bounds) >= 5:
				added.append(cell)
		growing = not added.is_empty()
		for cell: Vector2i in added:
			land.add(cell)
	return land


func _sand(land: Set, bounds: Vector2i) -> Set:
	var sand: Set = _coastline(land, bounds)
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


# Walk the remaining land from top to bottom, left to right. A cell becomes a
# tree when every stamped neighbour is land that is not sand.
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


# One simultaneous growth step. A land cell becomes a tree when four neighbours
# are trees and none of them is sand.
func _grow(land: Set, sand: Set, trees: Set) -> void:
	var added: Array[Vector2i] = []
	for cell: Vector2i in land:
		if sand.contains(cell) or trees.contains(cell):
			continue
		if _can_grow(sand, trees, cell):
			added.append(cell)
	for cell: Vector2i in added:
		trees.add(cell)


func _can_grow(sand: Set, trees: Set, cell: Vector2i) -> bool:
	var nearby: int = 0
	for offset: Vector2i in ECodes.ALL_NEIGHBORS:
		var neighbor: Vector2i = cell + offset
		if sand.contains(neighbor):
			return false
		if trees.contains(neighbor):
			nearby += 1
	return nearby >= 4


func _coastline(land: Set, bounds: Vector2i) -> Set:
	var sand: Set = Set.new()
	for cell: Vector2i in land:
		if _touches_water(land, cell, bounds):
			sand.add(cell)
	return sand


func _touches_water(land: Set, cell: Vector2i, bounds: Vector2i) -> bool:
	for offset: Vector2i in ECodes.ALL_NEIGHBORS:
		var neighbor: Vector2i = cell + offset
		if not _inside(neighbor, bounds) or not land.contains(neighbor):
			return true
	return false


func _sand_support(sand: Set, cell: Vector2i) -> int:
	var count: int = 0
	for offset: Vector2i in ECodes.ALL_NEIGHBORS:
		if sand.contains(cell + offset):
			count += 1
	return count


func _frontier(land: Set, bounds: Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	var seen: Set = Set.new()
	for cell: Vector2i in land:
		for offset: Vector2i in ECodes.ALL_NEIGHBORS:
			var neighbor: Vector2i = cell + offset
			if not _inside(neighbor, bounds) or land.contains(neighbor) or seen.contains(neighbor):
				continue
			seen.add(neighbor)
			cells.append(neighbor)
	return cells


func _support(grid: Array[Array], land: Set, cell: Vector2i, bounds: Vector2i) -> int:
	var count: int = 0
	for offset: Vector2i in ECodes.ALL_NEIGHBORS:
		var neighbor: Vector2i = cell + offset
		if not _inside(neighbor, bounds):
			continue
		if land.contains(neighbor) or grid[neighbor.y][neighbor.x] == "1":
			count += 1
	return count


func _inside(cell: Vector2i, bounds: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < bounds.x and cell.y < bounds.y
