class_name Q05 extends RefCounted

const DARK: int = 1
const LAND: int = 2
const SAND: int = 4
const TREE: int = 8
const QUEUED: int = 16
const CLEAR_QUEUED: int = 255 ^ QUEUED

# Cells that must be land or trees in the 5 by 5 stamp. Dots are omitted.
const STAMP: Array[Vector2i] = [
	Vector2i(-1, -2), Vector2i(0, -2), Vector2i(1, -2),
	Vector2i(-2, -1), Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1), Vector2i(2, -1),
	Vector2i(-2, 0), Vector2i(-1, 0), Vector2i(1, 0), Vector2i(2, 0),
	Vector2i(-2, 1), Vector2i(-1, 1), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1),
	Vector2i(-1, 2), Vector2i(0, 2), Vector2i(1, 2),
]

var _cells: PackedByteArray = PackedByteArray()
var _cols: int = 0
var _rows: int = 0
var _land_cells: Array[Vector2i] = []

func part1(data: String) -> String:
	_prepare(data)
	return str(_land_cells.size())


func part2(data: String) -> String:
	_prepare(data)
	_fill_sand()
	return str(_count(SAND))


func part3(data: String) -> String:
	_prepare(data)
	_fill_sand()
	_stamp()
	_grow()
	_grow()
	return str(_count(TREE))


func _prepare(data: String) -> void:
	var grid: Array[Array] = ECodes.string_to_2d_char_array(data.replace("\r", "").strip_edges())
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	_cols = size.y
	_rows = size.x
	_cells = PackedByteArray()
	_cells.resize(_cols * _rows)
	_land_cells = []
	for y: int in _rows:
		var row: Array = grid[y]
		var base: int = y * _cols
		for x: int in _cols:
			if row[x] == "1":
				_cells[base + x] = DARK
	_fill_land()


# Seed the centre, then keep a queue of cells that touch new land. A cell is
# checked again only after another neighbour becomes land.
func _fill_land() -> void:
	var queue: Array[Vector2i] = []
	@warning_ignore("integer_division")
	var center: Vector2i = Vector2i(_cols / 2, _rows / 2)
	_mark(center, LAND)
	_land_cells.append(center)
	_enqueue_around(center, queue, LAND)
	var head: int = 0
	while head < queue.size():
		var cell: Vector2i = queue[head]
		head += 1
		_clear_queued(cell)
		if _has(cell, LAND):
			continue
		if _land_support(cell) < 5:
			continue
		_mark(cell, LAND)
		_land_cells.append(cell)
		_enqueue_around(cell, queue, LAND)


# Sand starts on land that touches water, then spreads to land with five sand
# neighbours. Only neighbours of new sand are checked again.
func _fill_sand() -> void:
	var queue: Array[Vector2i] = []
	for cell: Vector2i in _land_cells:
		if _touches_water(cell):
			_mark(cell, SAND)
			_enqueue(cell, queue)
	var head: int = 0
	while head < queue.size():
		var cell: Vector2i = queue[head]
		head += 1
		_clear_queued(cell)
		for offset: Vector2i in ECodes.ALL_NEIGHBORS:
			var neighbor: Vector2i = cell + offset
			if not _inside(neighbor) or not _has(neighbor, LAND) or _has(neighbor, SAND):
				continue
			if _sand_support(neighbor) >= 5:
				_mark(neighbor, SAND)
				_enqueue(neighbor, queue)


# Reading order. Earlier trees stay land, so they still satisfy a later stamp.
func _stamp() -> void:
	for y: int in _rows:
		var base: int = y * _cols
		for x: int in _cols:
			var value: int = _cells[base + x]
			if (value & LAND) == 0 or (value & SAND) != 0:
				continue
			var cell: Vector2i = Vector2i(x, y)
			if _stamp_fits(cell):
				_mark(cell, TREE)


func _stamp_fits(cell: Vector2i) -> bool:
	for offset: Vector2i in STAMP:
		var neighbor: Vector2i = cell + offset
		if not _inside(neighbor):
			return false
		var value: int = _cells[_index(neighbor)]
		if (value & LAND) == 0 or (value & SAND) != 0:
			return false
	return true


# One simultaneous growth step.
func _grow() -> void:
	var added: Array[Vector2i] = []
	for cell: Vector2i in _land_cells:
		var value: int = _cells[_index(cell)]
		if (value & SAND) != 0 or (value & TREE) != 0:
			continue
		if _can_grow(cell):
			added.append(cell)
	for cell: Vector2i in added:
		_mark(cell, TREE)


func _can_grow(cell: Vector2i) -> bool:
	var nearby: int = 0
	for offset: Vector2i in ECodes.ALL_NEIGHBORS:
		var neighbor: Vector2i = cell + offset
		if not _inside(neighbor):
			continue
		var value: int = _cells[_index(neighbor)]
		if (value & SAND) != 0:
			return false
		if (value & TREE) != 0:
			nearby += 1
	return nearby >= 4


func _touches_water(cell: Vector2i) -> bool:
	for offset: Vector2i in ECodes.ALL_NEIGHBORS:
		var neighbor: Vector2i = cell + offset
		if not _inside(neighbor) or not _has(neighbor, LAND):
			return true
	return false


func _land_support(cell: Vector2i) -> int:
	var count: int = 0
	for offset: Vector2i in ECodes.ALL_NEIGHBORS:
		var neighbor: Vector2i = cell + offset
		if not _inside(neighbor):
			continue
		var value: int = _cells[_index(neighbor)]
		if (value & (LAND | DARK)) != 0:
			count += 1
	return count


func _sand_support(cell: Vector2i) -> int:
	var count: int = 0
	for offset: Vector2i in ECodes.ALL_NEIGHBORS:
		var neighbor: Vector2i = cell + offset
		if _inside(neighbor) and _has(neighbor, SAND):
			count += 1
	return count


func _enqueue_around(cell: Vector2i, queue: Array[Vector2i], blocked: int) -> void:
	for offset: Vector2i in ECodes.ALL_NEIGHBORS:
		var neighbor: Vector2i = cell + offset
		if _inside(neighbor) and not _has(neighbor, blocked):
			_enqueue(neighbor, queue)


func _enqueue(cell: Vector2i, queue: Array[Vector2i]) -> void:
	var index: int = _index(cell)
	if (_cells[index] & QUEUED) != 0:
		return
	_cells[index] = _cells[index] | QUEUED
	queue.append(cell)


func _clear_queued(cell: Vector2i) -> void:
	var index: int = _index(cell)
	_cells[index] = _cells[index] & CLEAR_QUEUED


func _mark(cell: Vector2i, flag: int) -> void:
	var index: int = _index(cell)
	_cells[index] = _cells[index] | flag


func _has(cell: Vector2i, flag: int) -> bool:
	return (_cells[_index(cell)] & flag) != 0


func _count(flag: int) -> int:
	var total: int = 0
	for cell: Vector2i in _land_cells:
		if _has(cell, flag):
			total += 1
	return total


func _index(cell: Vector2i) -> int:
	return cell.y * _cols + cell.x


func _inside(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < _cols and cell.y < _rows
