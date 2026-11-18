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
	return str(data.length())


func part3(data: String) -> String:
	return str(data.length())
