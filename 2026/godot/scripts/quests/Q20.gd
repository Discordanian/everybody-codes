class_name Q20 extends RefCounted

const _DIGIT_SEGMENTS: PackedInt32Array = [6, 2, 5, 5, 4, 5, 6, 3, 7, 6]


func part1(data: String) -> String:
	var total: int = 0
	for line: String in ECodes.string_to_lines(data.strip_edges()):
		if line.is_empty():
			continue
		if _balanced(line):
			total += _segments(line)
	return str(total)


func part2(data: String) -> String:
	return str(data.length())


func part3(data: String) -> String:
	return str(data.length())


func _balanced(line: String) -> bool:
	var sides: PackedStringArray = line.split(" = ")
	return _value(sides[0]) == _value(sides[1])


func _value(expr: String) -> int:
	var adding: bool = expr.contains("+")
	var parts: PackedStringArray = expr.split(" + " if adding else " - ")
	var left: int = int(parts[0])
	var right: int = int(parts[1])
	return left + right if adding else left - right


func _segments(line: String) -> int:
	var count: int = 0
	for index: int in line.length():
		var mark: String = line[index]
		if mark >= "0" and mark <= "9":
			count += _DIGIT_SEGMENTS[int(mark)]
		elif mark == "+":
			count += 2
		elif mark == "-":
			count += 1
		elif mark == "=":
			count += 2
	return count
