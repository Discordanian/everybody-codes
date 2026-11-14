class_name Q15 extends RefCounted

func part1(data: String) -> String:
	return str(_route(data))


func part2(data: String) -> String:
	return str(data.length())


func part3(data: String) -> String:
	return str(data.length())


# Shortest drive from S to E that passes every @. The wagon may go straight or
# turn left or right, and it cannot reverse in one move.
func _route(data: String) -> int:
	var grid: Array[Array] = ECodes.string_to_2d_char_array(data.strip_edges())
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	var rows: int = size.x
	var cols: int = size.y
	var facing: Array[Vector2i] = [ECodes.EAST, ECodes.SOUTH, ECodes.WEST, ECodes.NORTH]
	var ids: Dictionary = {}
	var deposit_of: PackedInt32Array = PackedInt32Array()
	var start: int = -1
	var goal: int = -1
	var deposits: int = 0
	for y: int in rows:
		for x: int in cols:
			var cell: String = grid[y][x]
			if cell == "#":
				continue
			ids[Vector2i(x, y)] = deposit_of.size()
			var bit: int = -1
			if cell == "S":
				start = deposit_of.size()
			elif cell == "E":
				goal = deposit_of.size()
			elif cell == "@":
				bit = deposits
				deposits += 1
			deposit_of.append(bit)
	var count: int = deposit_of.size()
	var ahead: PackedInt32Array = PackedInt32Array()
	ahead.resize(count * 4)
	ahead.fill(-1)
	for place: Vector2i in ids:
		var here: int = ids[place]
		for dir: int in 4:
			var step: Vector2i = place + facing[dir]
			if ids.has(step):
				ahead[here * 4 + dir] = ids[step]
	var full: int = (1 << deposits) - 1
	var seen: Dictionary = {}
	var q_cell: PackedInt32Array = PackedInt32Array()
	var q_dir: PackedInt32Array = PackedInt32Array()
	var q_mask: PackedInt32Array = PackedInt32Array()
	var q_dist: PackedInt32Array = PackedInt32Array()
	for dir: int in 4:
		var first: int = ahead[start * 4 + dir]
		if first < 0:
			continue
		var mask: int = 0
		if deposit_of[first] >= 0:
			mask = 1 << deposit_of[first]
		_push(seen, q_cell, q_dir, q_mask, q_dist, first, dir, mask, 1, deposits)
	var head: int = 0
	while head < q_cell.size():
		var cell: int = q_cell[head]
		var dir: int = q_dir[head]
		var mask: int = q_mask[head]
		var dist: int = q_dist[head]
		head += 1
		if cell == goal and mask == full:
			return dist
		for turn: int in [0, 1, 3]:
			var next_dir: int = (dir + turn) % 4
			var nxt: int = ahead[cell * 4 + next_dir]
			if nxt < 0:
				continue
			var next_mask: int = mask
			if deposit_of[nxt] >= 0:
				next_mask |= 1 << deposit_of[nxt]
			_push(seen, q_cell, q_dir, q_mask, q_dist, nxt, next_dir, next_mask, dist + 1, deposits)
	return -1


func _push(
	seen: Dictionary,
	q_cell: PackedInt32Array,
	q_dir: PackedInt32Array,
	q_mask: PackedInt32Array,
	q_dist: PackedInt32Array,
	cell: int,
	dir: int,
	mask: int,
	dist: int,
	deposits: int,
) -> void:
	var state: int = ((cell * 4 + dir) << deposits) | mask
	if seen.has(state):
		return
	seen[state] = true
	q_cell.append(cell)
	q_dir.append(dir)
	q_mask.append(mask)
	q_dist.append(dist)
