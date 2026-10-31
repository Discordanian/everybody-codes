class_name Q05 extends RefCounted

func part1(data: String) -> String:
	return str(_land_count(data))


func part2(data: String) -> String:
	return str(data.length())


func part3(data: String) -> String:
	return str(data.length())


# Seed the centre cell, then attach any frontier cell with at least five
# neighbours that are already land or dark on the original map.
func _land_count(data: String) -> int:
	var grid: Array[Array] = ECodes.string_to_2d_char_array(data.replace("\r", "").strip_edges())
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	var rows: int = size.x
	var cols: int = size.y
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
	return land.size()


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
