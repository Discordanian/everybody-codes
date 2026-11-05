class_name Q08 extends RefCounted

# Hex steps on the dotted map: southeast, southwest, west, northwest, northeast, east.
const DIRECTIONS: Array[Vector2i] = [
	Vector2i(1, 1),
	Vector2i(1, -1),
	Vector2i(0, -2),
	Vector2i(-1, -1),
	Vector2i(-1, 1),
	Vector2i(0, 2),
]

func part1(data: String) -> String:
	return str(_lit(_ents(data), DIRECTIONS[0]))


func part2(data: String) -> String:
	var ents: Array[Vector3i] = _ents(data)
	var total: int = 0
	for dir: Vector2i in DIRECTIONS:
		total += _lit(ents, dir)
	return str(total)


func part3(data: String) -> String:
	return str(data.length())


func _ents(data: String) -> Array[Vector3i]:
	var grid: Array[Array] = ECodes.string_to_2d_char_array(data.replace("\r", "").strip_edges())
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	var ents: Array[Vector3i] = []
	for r: int in size.x:
		var row: Array = grid[r]
		for c: int in size.y:
			var ch: String = row[c]
			if ch.is_valid_int():
				ents.append(Vector3i(r, c, ch.to_int()))
	return ents


# For a light in one direction. A taller Ent is lit, then the shadow drops by one hex.
func _lit(ents: Array[Vector3i], dir: Vector2i) -> int:
	var rays: Dictionary[int, Array] = {}
	for ent: Vector3i in ents:
		var lane: int = ent.x * dir.y - ent.y * dir.x
		var key: int = ent.x * dir.x + ent.y * dir.y
		if not rays.has(lane):
			rays[lane] = []
		rays[lane].append(Vector2i(key, ent.z))
	var total: int = 0
	for lane: int in rays:
		var cells: Array = rays[lane]
		cells.sort_custom(_earlier)
		var shadow: int = 0
		for cell: Vector2i in cells:
			if cell.y > shadow:
				total += 1
			shadow = maxi(shadow - 1, cell.y - 1)
	return total


func _earlier(a: Vector2i, b: Vector2i) -> bool:
	return a.x < b.x
