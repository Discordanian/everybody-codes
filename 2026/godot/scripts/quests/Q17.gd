class_name Q17 extends RefCounted

func part1(data: String) -> String:
	var grid: Array[Array] = ECodes.string_to_2d_char_array(data.strip_edges())
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	var rows: int = size.x
	var cols: int = size.y
	var goal_cell: Vector2i = Vector2i(cols - 1, rows - 1)
	var next_cells: Callable = func(cell: Variant) -> Array[Variant]:
		var here: Vector2i = cell
		var neighbors: Array[Variant] = []
		for step: Vector2i in ECodes.NEIGHBORS:
			var nxt: Vector2i = here + step
			if nxt.x < 0 or nxt.y < 0 or nxt.x >= cols or nxt.y >= rows:
				continue
			if grid[nxt.y][nxt.x] != "#":
				continue
			neighbors.append(nxt)
		return neighbors
	var is_goal: Callable = func(cell: Variant) -> bool:
		return cell == goal_cell
	return str(AoCGraph.bfs(Vector2i(0, 0), next_cells, is_goal))


func part2(data: String) -> String:
	var grid: Array[Array] = ECodes.string_to_2d_char_array(data.strip_edges())
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	var rows: int = size.x
	var cols: int = size.y
	var loop: int = 0
	for y: int in rows:
		for x: int in cols:
			if grid[y][x] != "#":
				continue
			for step: Vector2i in ECodes.NEIGHBORS:
				var nxt: Vector2i = Vector2i(x, y) + step
				if nxt.x < 0 or nxt.y < 0 or nxt.x >= cols or nxt.y >= rows or grid[nxt.y][nxt.x] != "#":
					loop += 1
	return str(loop)


func part3(data: String) -> String:
	var grid: Array[Array] = ECodes.string_to_2d_char_array(data.strip_edges())
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	return str(_shorter_rim(grid, size.x, size.y))


# Facing order is clockwise, so adding 1 turns right and keeps the crust on the right.
const _FACING: Array[Vector2i] = [ECodes.EAST, ECodes.SOUTH, ECodes.WEST, ECodes.NORTH]


func _shorter_rim(grid: Array[Array], rows: int, cols: int) -> int:
	var at: Vector2i = Vector2i(0, 0)
	var facing: int = 0
	var steps: int = 0
	var to_herb: int = -1
	var herb: Vector2i = Vector2i(cols, rows)
	var seen: Dictionary = {}
	while true:
		var key: Vector3i = Vector3i(at.x, at.y, facing)
		if seen.has(key):
			break
		seen[key] = true
		at += _FACING[facing]
		steps += 1
		if at == herb and to_herb < 0:
			to_herb = steps
		for turn: int in [1, 0, 3, 2]:
			var nxt: int = (facing + turn) % 4
			if _on_rim(grid, rows, cols, at, nxt):
				facing = nxt
				break
		if at == Vector2i.ZERO and facing == 0:
			break
	return mini(to_herb, steps - to_herb)


func _on_rim(grid: Array[Array], rows: int, cols: int, at: Vector2i, facing: int) -> bool:
	var step: Vector2i = _FACING[facing]
	if step.x != 0:
		var col: int = at.x if step.x > 0 else at.x - 1
		return _crust(grid, rows, cols, at.y - 1, col) != _crust(grid, rows, cols, at.y, col)
	var row: int = at.y if step.y > 0 else at.y - 1
	return _crust(grid, rows, cols, row, at.x - 1) != _crust(grid, rows, cols, row, at.x)


func _crust(grid: Array[Array], rows: int, cols: int, y: int, x: int) -> bool:
	return x >= 0 and y >= 0 and x < cols and y < rows and grid[y][x] == "#"
