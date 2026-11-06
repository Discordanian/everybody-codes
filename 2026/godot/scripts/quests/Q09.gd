class_name Q09 extends RefCounted

func part1(data: String) -> String:
	return str(_total(data, false))


func part2(data: String) -> String:
	return str(_total(data, true))


func part3(data: String) -> String:
	var total: int = 0
	for line: String in ECodes.string_to_lines(data.strip_edges()):
		if line.is_empty():
			continue
		var fields: PackedStringArray = line.split(", ", false)
		var growth: int = fields[1].trim_prefix("growth=").to_int()
		var limit: int = fields[2].trim_prefix("limit=").to_int()
		total += _leaf_seconds(growth, limit)
	return str(total)


func _total(data: String, count_leaves: bool) -> int:
	var total: int = 0
	for line: String in ECodes.string_to_lines(data.strip_edges()):
		if line.is_empty():
			continue
		var fields: PackedStringArray = line.split(", ", false)
		var growth: int = fields[1].trim_prefix("growth=").to_int()
		var limit: int = fields[2].trim_prefix("limit=").to_int()
		total += _seconds(growth, limit, count_leaves)
	return total


func _seconds(growth: int, limit: int, count_leaves: bool) -> int:
	var counts: PackedInt64Array = PackedInt64Array()
	counts.resize(growth)
	counts[0] = 1
	var junctions: int = 0
	var measure: int = 0
	var seconds: int = 0
	@warning_ignore("integer_division")
	var half: int = growth / 2
	while measure < limit:
		seconds += 1
		var splits: int = counts[growth - 1]
		var nxt: PackedInt64Array = PackedInt64Array()
		nxt.resize(growth)
		for length: int in range(growth - 1):
			nxt[length + 1] = counts[length]
		nxt[half] += splits * 2
		nxt[1] += splits
		junctions += splits
		counts = nxt
		if count_leaves:
			measure = 1 + junctions
		else:
			measure = junctions
			for length: int in growth:
				measure += length * counts[length]
	return seconds


# Splits happen at t + growth - 1 .  
func _leaf_seconds(growth: int, limit: int) -> int:
	if limit <= 1:
		return 1
	var due: Dictionary[int, int] = {}
	var heap: MinHeap = MinHeap.new()
	_schedule(heap, due, growth, 1)
	var leaves: int = 1
	@warning_ignore("integer_division")
	var short_wait: int = growth / 2 + 1
	var long_wait: int = growth - 1
	while leaves < limit:
		var when: int = int(heap.pop()["p"])
		var splits: int = due[when]
		due.erase(when)
		leaves += splits
		if leaves >= limit:
			return when
		_schedule(heap, due, when + long_wait, splits)
		_schedule(heap, due, when + short_wait, splits * 2)
	return 0


func _schedule(heap: MinHeap, due: Dictionary[int, int], time: int, count: int) -> void:
	if due.has(time):
		due[time] += count
		return
	due[time] = count
	heap.push(time, time)
