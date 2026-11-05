class_name Q08 extends RefCounted

const ARMY: int = 100000

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
	var ents: Array[Vector3i] = _ents(data)
	var count: int = ents.size()
	var height: PackedInt32Array = PackedInt32Array()
	var sprout: PackedInt32Array = PackedInt32Array()
	height.resize(count)
	sprout.resize(count)
	sprout.fill(-1)
	var pos: Array[Vector2i] = []
	pos.resize(count)
	for i: int in count:
		var ent: Vector3i = ents[i]
		pos[i] = Vector2i(ent.x, ent.y)
		height[i] = ent.z
	var all_rays: Array = []
	var step_units: PackedInt32Array = PackedInt32Array()
	step_units.resize(DIRECTIONS.size())
	for d: int in DIRECTIONS.size():
		var dir: Vector2i = DIRECTIONS[d]
		step_units[d] = dir.x * dir.x + dir.y * dir.y
		all_rays.append(_index_rays(pos, dir))
	var energy: int = 0
	var warriors: int = 0
	var round: int = 0
	while warriors < ARMY:
		for i: int in count:
			if sprout[i] == round:
				height[i] = 1
				sprout[i] = -1
		var lit: Array[int] = _lit_ids(all_rays[round % DIRECTIONS.size()], step_units[round % DIRECTIONS.size()], height)
		energy += lit.size()
		for idx: int in lit:
			if height[idx] == 9:
				height[idx] = 0
				sprout[idx] = round + 4
				warriors += 1
			else:
				height[idx] += 1
		round += 1
	return str(energy)


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


# Each ray stores (distance, ent index), ordered from the light toward its shadow.
func _index_rays(pos: Array[Vector2i], dir: Vector2i) -> Array:
	var groups: Dictionary[int, Array] = {}
	for i: int in pos.size():
		var at: Vector2i = pos[i]
		var lane: int = at.x * dir.y - at.y * dir.x
		var key: int = at.x * dir.x + at.y * dir.y
		if not groups.has(lane):
			groups[lane] = []
		groups[lane].append(Vector2i(key, i))
	var rays: Array = []
	for lane: int in groups:
		var cells: Array = groups[lane]
		cells.sort_custom(_earlier)
		rays.append(cells)
	return rays


# Shadows are fixed before growth. An underground seed is skipped, and the shade still falls by one level per hex.
func _lit_ids(rays: Array, step_unit: int, height: PackedInt32Array) -> Array[int]:
	var lit: Array[int] = []
	for ray: Array in rays:
		var has_prev: bool = false
		var prev_key: int = 0
		var prev_shade: int = 0
		var prev_height: int = 0
		for cell: Vector2i in ray:
			var idx: int = cell.y
			var h: int = height[idx]
			if h == 0:
				continue
			var shade: int = 0
			if has_prev:
				var jumped: int = (cell.x - prev_key) / step_unit
				shade = maxi(prev_shade - jumped, prev_height - jumped)
				if shade < 0:
					shade = 0
			if h > shade:
				lit.append(idx)
			prev_key = cell.x
			prev_shade = shade
			prev_height = h
			has_prev = true
	return lit
