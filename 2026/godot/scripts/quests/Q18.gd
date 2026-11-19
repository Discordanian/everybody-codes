class_name Q18 extends RefCounted

func part1(data: String) -> String:
	return str(_material(data, false))


func part2(data: String) -> String:
	return str(_material(data, true))


func _material(data: String, use_width: bool) -> int:
	var columns: PackedInt32Array = PackedInt32Array()
	var heights: PackedInt32Array = PackedInt32Array()
	var widths: PackedInt32Array = PackedInt32Array()
	var tallest: int = 0
	for line: String in ECodes.string_to_lines(data.strip_edges()):
		if line.is_empty():
			continue
		var numbers: Array[int] = ECodes.array_int_from_string(line)
		columns.append(numbers[0])
		heights.append(numbers[1])
		widths.append(numbers[2] if use_width else 1)
		if numbers[1] > tallest:
			tallest = numbers[1]
	var total: int = 0
	for level: int in range(1, tallest + 1):
		var left: int = 2147483647
		var right: int = -1
		for index: int in columns.size():
			if heights[index] < level:
				continue
			var end_column: int = columns[index] + widths[index] - 1
			if columns[index] < left:
				left = columns[index]
			if end_column > right:
				right = end_column
		total += right - left + 1
	return total


func part3(data: String) -> String:
	var columns: PackedInt32Array = PackedInt32Array()
	var heights: PackedInt32Array = PackedInt32Array()
	var widths: PackedInt32Array = PackedInt32Array()
	for line: String in ECodes.string_to_lines(data.strip_edges()):
		if line.is_empty():
			continue
		var numbers: Array[int] = ECodes.array_int_from_string(line)
		columns.append(numbers[0])
		heights.append(numbers[1])
		widths.append(numbers[2])
	var order: Array[int] = []
	for index: int in columns.size():
		order.append(index)
	order.sort_custom(func(a: int, b: int) -> bool: return heights[a] > heights[b])
	var left: int = 2147483647
	var right: int = -1
	var total: int = 0
	var cursor: int = 0
	var count: int = order.size()
	while cursor < count:
		var height: int = heights[order[cursor]]
		while cursor < count and heights[order[cursor]] == height:
			var index: int = order[cursor]
			var end_column: int = columns[index] + widths[index] - 1
			if columns[index] < left:
				left = columns[index]
			if end_column > right:
				right = end_column
			cursor += 1
		var lower: int = 0
		if cursor < count:
			lower = heights[order[cursor]]
		var rows: int = height - lower
		total += rows * (right - left + 1)
	return str(total)
