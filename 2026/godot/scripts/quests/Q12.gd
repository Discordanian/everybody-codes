class_name Q12 extends RefCounted

func part1(data: String) -> String:
	return str(_spells(data))


func part2(data: String) -> String:
	return str(_spells(data))


func part3(data: String) -> String:
	var grid: Array[Array] = ECodes.string_to_2d_char_array(data.strip_edges())
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	var rows: int = size.x
	var cols: int = size.y
	var across: PackedInt32Array = PackedInt32Array()
	var down: PackedInt32Array = PackedInt32Array()
	across.resize(rows * cols)
	down.resize(rows * cols)
	across.fill(-1)
	down.fill(-1)
	var across_count: int = 0
	for y: int in rows:
		var x: int = 0
		while x < cols:
			if grid[y][x] != "#":
				x += 1
				continue
			var run: int = across_count
			across_count += 1
			while x < cols and grid[y][x] == "#":
				across[y * cols + x] = run
				x += 1
	var down_count: int = 0
	for x: int in cols:
		var y: int = 0
		while y < rows:
			if grid[y][x] != "#":
				y += 1
				continue
			var run: int = down_count
			down_count += 1
			while y < rows and grid[y][x] == "#":
				down[y * cols + x] = run
				y += 1
	_links = []
	_links.resize(across_count)
	for run: int in across_count:
		_links[run] = []
	for y: int in rows:
		for x: int in cols:
			if grid[y][x] != "#":
				continue
			_links[across[y * cols + x]].append(down[y * cols + x])
	_pair = PackedInt32Array()
	_pair.resize(down_count)
	_pair.fill(-1)
	_seen = PackedByteArray()
	_seen.resize(down_count)
	var spells: int = 0
	for run: int in across_count:
		_seen.fill(0)
		if _cover(run):
			spells += 1
	return str(spells)


# A rectangle needs one spell per row or one per column. An L is that rectangle
# with one corner missing, and it can also be cleared by covering each arm once.
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
	var height: int = max_at.y - min_at.y + 1
	var width: int = max_at.x - min_at.x + 1
	var hole_min: Vector2i = max_at
	var hole_max: Vector2i = min_at
	var hole: bool = false
	for y: int in range(min_at.y, max_at.y + 1):
		for x: int in range(min_at.x, max_at.x + 1):
			if grid[y][x] == "#":
				continue
			hole = true
			var at: Vector2i = Vector2i(x, y)
			hole_min = hole_min.min(at)
			hole_max = hole_max.max(at)
	var spells: int = mini(height, width)
	if hole:
		var arm: int = (height - (hole_max.y - hole_min.y + 1)) + (width - (hole_max.x - hole_min.x + 1))
		spells = mini(spells, arm)
	return spells


func _spells(data: String) -> int:
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
	return spells


var _links: Array = []
var _pair: PackedInt32Array = PackedInt32Array()
var _seen: PackedByteArray = PackedByteArray()


# A horizontal run and a vertical run share a block when they cross. 
func _cover(run: int) -> bool:
	for other: int in _links[run]:
		if _seen[other] != 0:
			continue
		_seen[other] = 1
		if _pair[other] < 0 or _cover(_pair[other]):
			_pair[other] = run
			return true
	return false
