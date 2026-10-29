class_name Q03 extends RefCounted

func _pow(base: int, exponent: int) -> int:
	var result: int = 1
	var power: int = exponent
	while power > 0:
		result *= base
		power -= 1
	return result


func _line_value(line: String) -> int:
	var parts: PackedStringArray = line.split(" ", false)
	var places: String = parts[0].trim_prefix("ISO-")
	var values: String = parts[1]
	var total: int = 0
	var last_place: int = places.length() - 1
	for index: int in places.length():
		var base: int = places[index].to_int()
		var digit: int = values[index].to_int()
		total += digit * _pow(base, last_place - index)
	return total


func part1(data: String) -> String:
	var total: int = 0
	for line: String in ECodes.string_to_lines(data):
		if line.is_empty():
			continue
		total += _line_value(line)
	return str(total)


func part2(data: String) -> String:
	return str(data.length())


func part3(data: String) -> String:
	return str(data.length())
