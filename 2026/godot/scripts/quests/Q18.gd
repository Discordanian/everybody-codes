class_name Q18 extends RefCounted

func part1(data: String) -> String:
	var columns: PackedInt32Array = PackedInt32Array()
	var heights: PackedInt32Array = PackedInt32Array()
	var tallest: int = 0
	for line: String in ECodes.string_to_lines(data.strip_edges()):
		if line.is_empty():
			continue
		var numbers: Array[int] = ECodes.array_int_from_string(line)
		columns.append(numbers[0])
		heights.append(numbers[1])
		if numbers[1] > tallest:
			tallest = numbers[1]
	var total: int = 0
	for level: int in range(1, tallest + 1):
		var left: int = 2147483647
		var right: int = -1
		for index: int in columns.size():
			if heights[index] < level:
				continue
			if columns[index] < left:
				left = columns[index]
			if columns[index] > right:
				right = columns[index]
		total += right - left + 1
	return str(total)


func part2(data: String) -> String:
	return str(data.length())


func part3(data: String) -> String:
	return str(data.length())
