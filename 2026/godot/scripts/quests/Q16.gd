class_name Q16 extends RefCounted

const SHELF_COPIES: int = 10
const PART3_COPIES: int = 100


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
	var total: int = 0
	for line: String in ECodes.string_to_lines(data.strip_edges()):
		if line.is_empty():
			continue
		total += _gather_tablets(line.repeat(PART3_COPIES).to_ascii_buffer())
	return str(total)


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


func _gather_tablets(tablets: PackedByteArray) -> int:
	var total: int = 0
	while true:
		var runs: PackedInt32Array = _split_runs(tablets)
		if runs.is_empty():
			return total
		total += _gather_cost(runs)
		tablets = _gather_next(tablets, runs)
	return total


func _split_runs(tablets: PackedByteArray) -> PackedInt32Array:
	var run_count: PackedInt32Array = PackedInt32Array()
	var first_index: PackedInt32Array = PackedInt32Array()
	run_count.resize(128)
	first_index.resize(128)
	first_index.fill(-1)
	var count: int = tablets.size()
	var index: int = 0
	var end: int = 0
	while index < count:
		var shade: int = tablets[index]
		end = index + 1
		while end < count and tablets[end] == shade:
			end += 1
		run_count[shade] += 1
		if first_index[shade] < 0:
			first_index[shade] = index
		index = end
	var chosen: int = -1
	var best: int = 2147483647
	for shade: int in 128:
		if run_count[shade] > 1 and first_index[shade] < best:
			best = first_index[shade]
			chosen = shade
	var runs: PackedInt32Array = PackedInt32Array()
	if chosen < 0:
		return runs
	index = 0
	while index < count:
		if tablets[index] != chosen:
			index += 1
			continue
		end = index + 1
		while end < count and tablets[end] == chosen:
			end += 1
		runs.append(index)
		runs.append(end)
		index = end
	return runs


func _gather_cost(runs: PackedInt32Array) -> int:
	@warning_ignore("integer_division")
	var groups: int = runs.size() / 2
	var gaps: int = groups - 1
	var total: int = 0
	var length: int = 0
	var multiplier: int = 0
	for gap: int in gaps:
		length = runs[2 * gap + 2] - runs[2 * gap + 1]
		@warning_ignore("integer_division")
		if gap <= (gaps - 1) / 2:
			multiplier = 2 * gap + 1
		else:
			multiplier = 2 * (gaps - gap)
		total += multiplier * length
	for group: int in range(1, groups):
		length = runs[2 * group + 1] - runs[2 * group]
		@warning_ignore("integer_division")
		if group <= gaps / 2:
			multiplier = 2 * group
		else:
			multiplier = 2 * gaps - 2 * group + 1
		total += multiplier * length
	return total


func _gather_next(tablets: PackedByteArray, runs: PackedInt32Array) -> PackedByteArray:
	@warning_ignore("integer_division")
	var groups: int = runs.size() / 2
	var gaps: int = groups - 1
	var suffix_from: int = runs[2 * groups - 1]
	var out_length: int = tablets.size() - suffix_from
	for gap: int in gaps:
		out_length += runs[2 * gap + 2] - runs[2 * gap + 1]
	var out: PackedByteArray = PackedByteArray()
	out.resize(out_length)
	var dest: int = 0
	var src: int = 0
	var order: PackedInt32Array = _gap_order(gaps)
	for place: int in order.size():
		var gap: int = order[place]
		var left: int = runs[2 * gap + 1]
		var right: int = runs[2 * gap + 2]
		if _gap_flipped(gaps, place):
			src = right - 1
			while src >= left:
				out[dest] = tablets[src]
				dest += 1
				src -= 1
		else:
			src = left
			while src < right:
				out[dest] = tablets[src]
				dest += 1
				src += 1
	src = suffix_from
	var count: int = tablets.size()
	while src < count:
		out[dest] = tablets[src]
		dest += 1
		src += 1
	return out


func _gap_order(gaps: int) -> PackedInt32Array:
	var order: PackedInt32Array = PackedInt32Array()
	if gaps == 0:
		return order
	order.resize(gaps)
	@warning_ignore("integer_division")
	var mid: int = gaps / 2
	var place: int = 0
	order[place] = mid
	place += 1
	var step: int = 1
	if gaps % 2 == 0:
		while step < mid:
			order[place] = mid - step
			place += 1
			order[place] = mid + step
			place += 1
			step += 1
		order[place] = 0
	else:
		while step <= mid:
			order[place] = mid + step
			place += 1
			order[place] = mid - step
			place += 1
			step += 1
	return order


func _gap_flipped(gaps: int, place: int) -> bool:
	if gaps % 2 == 0:
		return place % 2 == 1
	return place % 2 == 0
