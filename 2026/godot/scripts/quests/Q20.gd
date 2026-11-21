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
	var moves: Dictionary = _segment_moves()
	var total: int = 0
	for line: String in ECodes.string_to_lines(data.strip_edges()):
		if line.is_empty():
			continue
		if _balanced(line, 11) or _one_move(line, moves):
			total += _segments(line)
	return _to_base(total, 11)


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


func _segment_moves() -> Dictionary:
	var masks: Dictionary = {
		"0": 63,
		"1": 6,
		"2": 91,
		"3": 79,
		"4": 102,
		"5": 109,
		"6": 125,
		"7": 7,
		"8": 127,
		"9": 111,
		"A": 119,
	}
	var by_mask: Dictionary = {}
	for glyph: String in masks:
		by_mask[int(masks[glyph])] = glyph
	var lose: Dictionary = {}
	var gain: Dictionary = {}
	var shift: Dictionary = {}
	for glyph: String in masks:
		var mask: int = int(masks[glyph])
		var lost: PackedStringArray = PackedStringArray()
		var gained: PackedStringArray = PackedStringArray()
		var shifted: PackedStringArray = PackedStringArray()
		for bit: int in 7:
			var flag: int = 1 << bit
			if (mask & flag) != 0:
				var removed: int = mask ^ flag
				if by_mask.has(removed):
					lost.append(by_mask[removed])
			else:
				var added: int = mask | flag
				if by_mask.has(added):
					gained.append(by_mask[added])
		for off: int in 7:
			var off_flag: int = 1 << off
			if (mask & off_flag) == 0:
				continue
			for on: int in 7:
				if off == on or (mask & (1 << on)) != 0:
					continue
				var moved: int = (mask ^ off_flag) | (1 << on)
				if by_mask.has(moved):
					shifted.append(by_mask[moved])
		lose[glyph] = lost
		gain[glyph] = gained
		shift[glyph] = shifted
	lose["+"] = PackedStringArray(["-"])
	gain["+"] = PackedStringArray()
	shift["+"] = PackedStringArray()
	lose["-"] = PackedStringArray()
	gain["-"] = PackedStringArray(["+"])
	shift["-"] = PackedStringArray()
	return {"lose": lose, "gain": gain, "shift": shift}


func _one_move(line: String, moves: Dictionary) -> bool:
	var lose: Dictionary = moves["lose"]
	var gain: Dictionary = moves["gain"]
	var shift: Dictionary = moves["shift"]
	var marks: PackedStringArray = PackedStringArray()
	var spots: PackedInt32Array = PackedInt32Array()
	for index: int in line.length():
		var mark: String = line[index]
		marks.append(mark)
		if lose.has(mark):
			spots.append(index)
	for place: int in spots:
		var mark: String = marks[place]
		var shifted: PackedStringArray = shift[mark]
		for next_mark: String in shifted:
			marks[place] = next_mark
			if _holds(marks):
				return true
		marks[place] = mark
	for source: int in spots:
		var origin: String = marks[source]
		var lost: PackedStringArray = lose[origin]
		if lost.is_empty():
			continue
		for target: int in spots:
			if target == source:
				continue
			var destination: String = marks[target]
			var gained: PackedStringArray = gain[destination]
			if gained.is_empty():
				continue
			for removed: String in lost:
				marks[source] = removed
				for added: String in gained:
					marks[target] = added
					if _holds(marks):
						return true
				marks[target] = destination
			marks[source] = origin
	return false


func _holds(marks: PackedStringArray) -> bool:
	var equal_at: int = 0
	for index: int in marks.size():
		if marks[index] == "=":
			equal_at = index
			break
	return _side_value(marks, 0, equal_at) == _side_value(marks, equal_at + 1, marks.size())


func _side_value(marks: PackedStringArray, start: int, end: int) -> int:
	var cursor: Array[int] = [start]
	var first: int = _read_number(marks, cursor, end)
	_skip_spaces(marks, cursor, end)
	var operator: String = marks[cursor[0]]
	cursor[0] += 1
	var second: int = _read_number(marks, cursor, end)
	return first + second if operator == "+" else first - second


func _read_number(marks: PackedStringArray, cursor: Array[int], end: int) -> int:
	var index: int = cursor[0]
	while index < end and marks[index] == " ":
		index += 1
	var value: int = 0
	while index < end and marks[index] != " " and marks[index] != "+" and marks[index] != "-" and marks[index] != "=":
		var digit: int = 10 if marks[index] == "A" else int(marks[index])
		value = value * 11 + digit
		index += 1
	cursor[0] = index
	return value


func _skip_spaces(marks: PackedStringArray, cursor: Array[int], end: int) -> void:
	var index: int = cursor[0]
	while index < end and marks[index] == " ":
		index += 1
	cursor[0] = index


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
