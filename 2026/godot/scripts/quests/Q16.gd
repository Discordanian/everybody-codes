class_name Q16 extends RefCounted

const SHELF_COPIES: int = 10


func part1(data: String) -> String:
	var total: int = 0
	for line: String in ECodes.string_to_lines(data.strip_edges()):
		if line.is_empty():
			continue
		total += _measure(_runs_from(line), true)
	return str(total)


func part2(data: String) -> String:
	var total: int = 0
	for line: String in ECodes.string_to_lines(data.strip_edges()):
		if line.is_empty():
			continue
		total += _measure(_runs_from(line.repeat(SHELF_COPIES)), false)
	return str(total)


func part3(data: String) -> String:
	return str(data.length())


# A run is Vector2i(shade, length). count_flips tallies flips; otherwise the tablets put back.
func _measure(runs: Array[Vector2i], count_flips: bool) -> int:
	var total: int = 0
	while true:
		var shade: int = _split_shade(runs)
		if shade < 0:
			return total
		var first: int = -1
		var last: int = -1
		for index: int in runs.size():
			if runs[index].x != shade:
				continue
			if first < 0:
				first = index
			last = index
		var length: int = 0
		for index: int in range(first + 1, last + 1):
			length += runs[index].y
		var left: int = first + 1
		var right: int = last
		while left < right:
			var swap: Vector2i = runs[left]
			runs[left] = runs[right]
			runs[right] = swap
			left += 1
			right -= 1
		runs[first] = Vector2i(shade, runs[first].y + runs[first + 1].y)
		runs.remove_at(first + 1)
		var boundary: int = last - 1
		if boundary + 1 < runs.size() and runs[boundary].x == runs[boundary + 1].x:
			var joined: Vector2i = runs[boundary]
			var after: Vector2i = runs[boundary + 1]
			runs[boundary] = Vector2i(joined.x, joined.y + after.y)
			runs.remove_at(boundary + 1)
		total += 1 if count_flips else length
	return total


func _split_shade(runs: Array[Vector2i]) -> int:
	var counts: Dictionary = {}
	var order: PackedInt32Array = PackedInt32Array()
	for run: Vector2i in runs:
		var shade: int = run.x
		if not counts.has(shade):
			counts[shade] = 0
			order.append(shade)
		counts[shade] = int(counts[shade]) + 1
	for shade: int in order:
		if int(counts[shade]) > 1:
			return shade
	return -1


func _runs_from(shelf: String) -> Array[Vector2i]:
	var runs: Array[Vector2i] = []
	var count: int = shelf.length()
	var index: int = 0
	while index < count:
		var shade: int = shelf.unicode_at(index)
		var end: int = index + 1
		while end < count and shelf.unicode_at(end) == shade:
			end += 1
		runs.append(Vector2i(shade, end - index))
		index = end
	return runs
