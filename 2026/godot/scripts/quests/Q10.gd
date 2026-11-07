class_name Q10 extends RefCounted

const ROUNDS: int = 10
const ENDURANCE: int = 10000
const ENDURANCE_3: int = 1000000000000

class Ghost:
	var id: int
	var at: Vector2i
	var dir: Vector2i
	var hits: int

	func _init(cell: Vector2i, facing: Vector2i) -> void:
		at = cell
		dir = facing
		hits = 0


func part1(data: String) -> String:
	var walls: Set = Set.new()
	var ghosts: Array[Ghost] = _ghosts(data, walls)
	var collisions: int = 0
	for _round: int in ROUNDS:
		collisions += _step(ghosts, walls, ENDURANCE)
	return str(collisions)


func part2(data: String) -> String:
	var walls: Set = Set.new()
	var ghosts: Array[Ghost] = _ghosts(data, walls)
	var round: int = 0
	while not ghosts.is_empty():
		round += 1
		_step(ghosts, walls, ENDURANCE)
	return str(round)


func part3(data: String) -> String:
	var walls: Set = Set.new()
	var ghosts: Array[Ghost] = _ghosts(data, walls)
	var seen: Dictionary = {}
	var round_no: int = 0
	while not ghosts.is_empty():
		var geom: String = _geom(ghosts)
		if seen.has(geom):
			var prev: Array = seen[geom]
			var started: int = prev[0]
			var shits: PackedInt64Array = prev[1]
			var period: int = round_no - started
			var deltas: PackedInt64Array = PackedInt64Array()
			deltas.resize(ghosts.size())
			var laps: int = -1
			for i: int in ghosts.size():
				var gain: int = ghosts[i].hits - shits[i]
				deltas[i] = gain
				if gain <= 0:
					continue
				@warning_ignore("integer_division")
				var can: int = (ENDURANCE_3 - 1 - ghosts[i].hits) / gain
				if laps < 0 or can < laps:
					laps = can
			if laps > 0:
				round_no += laps * period
				for i: int in ghosts.size():
					ghosts[i].hits += laps * deltas[i]
			seen.clear()
			if laps > 0:
				continue
		else:
			var snap: PackedInt64Array = PackedInt64Array()
			snap.resize(ghosts.size())
			for i: int in ghosts.size():
				snap[i] = ghosts[i].hits
			seen[geom] = [round_no, snap.duplicate()]
		var before: int = ghosts.size()
		_step(ghosts, walls, ENDURANCE_3)
		round_no += 1
		if ghosts.size() != before:
			seen.clear()
	return str(round_no)


func _ghosts(data: String, walls: Set) -> Array[Ghost]:
	var grid: Array[Array] = ECodes.string_to_2d_char_array(data.strip_edges())
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	var ghosts: Array[Ghost] = []
	for y: int in size.x:
		var row: Array = grid[y]
		for x: int in size.y:
			var ch: String = row[x]
			var cell: Vector2i = Vector2i(x, y)
			if ch == "#":
				walls.add(cell)
			elif ch == ">":
				ghosts.append(_make_ghost(cell, ECodes.EAST, ghosts.size()))
			elif ch == "<":
				ghosts.append(_make_ghost(cell, ECodes.WEST, ghosts.size()))
			elif ch == "^":
				ghosts.append(_make_ghost(cell, ECodes.NORTH, ghosts.size()))
			elif ch == "v":
				ghosts.append(_make_ghost(cell, ECodes.SOUTH, ghosts.size()))
	return ghosts


func _make_ghost(cell: Vector2i, facing: Vector2i, id: int) -> Ghost:
	var ghost: Ghost = Ghost.new(cell, facing)
	ghost.id = id
	return ghost


func _geom(ghosts: Array[Ghost]) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for ghost: Ghost in ghosts:
		parts.append("%d:%d,%d,%d,%d" % [ghost.id, ghost.at.x, ghost.at.y, ghost.dir.x, ghost.dir.y])
	return "|".join(parts)


# Everyone moves at once. A wall bounce turns clockwise and counts at once, so a ghost
# that reaches its limit is already gone before shared cells are checked. Ghosts that
# then share a cell each take one collision and turn around.
func _step(ghosts: Array[Ghost], walls: Set, limit: int) -> int:
	var collisions: int = 0
	var moving: Array[Ghost] = []
	for ghost: Ghost in ghosts:
		var nxt: Vector2i = ghost.at + ghost.dir
		if walls.contains(nxt):
			collisions += 1
			ghost.hits += 1
			ghost.dir = Vector2i(-ghost.dir.y, ghost.dir.x)
			if ghost.hits >= limit:
				continue
		else:
			ghost.at = nxt
		moving.append(ghost)
	var piles: Dictionary[Vector2i, Array] = {}
	for ghost: Ghost in moving:
		if not piles.has(ghost.at):
			piles[ghost.at] = []
		piles[ghost.at].append(ghost)
	ghosts.clear()
	for cell: Vector2i in piles:
		var pile: Array = piles[cell]
		if pile.size() < 2:
			ghosts.append(pile[0])
			continue
		collisions += pile.size()
		for ghost: Ghost in pile:
			ghost.hits += 1
			ghost.dir = -ghost.dir
			if ghost.hits < limit:
				ghosts.append(ghost)
	ghosts.sort_custom(_by_id)
	return collisions


func _by_id(a: Ghost, b: Ghost) -> bool:
	return a.id < b.id
