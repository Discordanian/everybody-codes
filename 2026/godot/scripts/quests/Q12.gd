class_name Q12 extends RefCounted

func part1(data: String) -> String:
	var grid: Array[Array] = ECodes.string_to_2d_char_array(data.strip_edges())
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	var seen: PackedByteArray = PackedByteArray()
	seen.resize(size.x * size.y)
	var spells: int = 0
	for y: int in size.x:
		var row: Array = grid[y]
		for x: int in size.y:
			if row[x] != "#" or seen[y * size.y + x] != 0:
				continue
			spells += _stack(grid, seen, size, Vector2i(x, y))
	return str(spells)


func part2(data: String) -> String:
	return str(data.length())


func part3(data: String) -> String:
	return str(data.length())


# A solid rectangle is covered by one spell per row, or one per column.
func _stack(grid: Array[Array], seen: PackedByteArray, size: Vector2i, start: Vector2i) -> int:
	var queue: Array[Vector2i] = [start]
	seen[start.y * size.y + start.x] = 1
	var head: int = 0
	var min_at: Vector2i = start
	var max_at: Vector2i = start
	while head < queue.size():
		var cell: Vector2i = queue[head]
		head += 1
		min_at = min_at.min(cell)
		max_at = max_at.max(cell)
		for step: Vector2i in ECodes.NEIGHBORS:
			var nxt: Vector2i = cell + step
			if nxt.x < 0 or nxt.y < 0 or nxt.x >= size.y or nxt.y >= size.x:
				continue
			if seen[nxt.y * size.y + nxt.x] != 0:
				continue
			if grid[nxt.y][nxt.x] != "#":
				continue
			seen[nxt.y * size.y + nxt.x] = 1
			queue.append(nxt)
	return mini(max_at.y - min_at.y + 1, max_at.x - min_at.x + 1)
