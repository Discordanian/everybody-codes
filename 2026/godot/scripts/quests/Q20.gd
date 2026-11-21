class_name Q20 extends RefCounted

const _DIGIT_SEGMENTS: PackedInt32Array = [6, 2, 5, 5, 4, 5, 6, 3, 7, 6]


func part1(data: String) -> String:
	var total: int = 0
	for line: String in ECodes.string_to_lines(data.strip_edges()):
		if line.is_empty():
			continue
		if _balanced(line, 10):
			total += _segments(line)
	return str(total)


func part2(data: String) -> String:
	var total: int = 0
	for line: String in ECodes.string_to_lines(data.strip_edges()):
		if line.is_empty():
			continue
		if _balanced(line, 11):
			total += _segments(line)
	return _to_base(total, 11)


func part3(data: String) -> String:
	return str(data.length())


func _balanced(line: String, base: int) -> bool:
	var sides: PackedStringArray = line.split(" = ")
	return _value(sides[0], base) == _value(sides[1], base)


func _value(expr: String, base: int) -> int:
	var adding: bool = expr.contains("+")
	var parts: PackedStringArray = expr.split(" + " if adding else " - ")
	var left: int = _from_base(parts[0], base)
	var right: int = _from_base(parts[1], base)
	return left + right if adding else left - right


func _from_base(token: String, base: int) -> int:
	var value: int = 0
	for index: int in token.length():
		var mark: String = token[index]
		var digit: int = 10 if mark == "A" else int(mark)
		value = value * base + digit
	return value


func _to_base(value: int, base: int) -> String:
	if value == 0:
		return "0"
	var glyphs: String = "0123456789A"
	var encoded: String = ""
	var rest: int = value
	while rest > 0:
		var digit: int = rest % base
		encoded = glyphs[digit] + encoded
		@warning_ignore("integer_division")
		rest = rest / base
	return encoded


func _segments(line: String) -> int:
	var count: int = 0
	for index: int in line.length():
		var mark: String = line[index]
		if mark == "A":
			count += 6
		elif mark >= "0" and mark <= "9":
			count += _DIGIT_SEGMENTS[int(mark)]
		elif mark == "+":
			count += 2
		elif mark == "-":
			count += 1
		elif mark == "=":
			count += 2
	return count
