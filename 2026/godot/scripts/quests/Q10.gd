class_name Q10 extends RefCounted

const ROUNDS: int = 10
const ENDURANCE: int = 10000

class Ghost:
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
	return str(data.length())


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
				ghosts.append(Ghost.new(cell, ECodes.EAST))
			elif ch == "<":
				ghosts.append(Ghost.new(cell, ECodes.WEST))
			elif ch == "^":
				ghosts.append(Ghost.new(cell, ECodes.NORTH))
			elif ch == "v":
				ghosts.append(Ghost.new(cell, ECodes.SOUTH))
	return ghosts


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
	return collisions
