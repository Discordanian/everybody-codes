class_name Q03 extends RefCounted

func _pow(base: int, exponent: int) -> int:
	var result: int = 1
	var power: int = exponent
	while power > 0:
		result *= base
		power -= 1
	return result


func _expanded_places(places: String, length: int) -> String:
	@warning_ignore("integer_division")
	var repeats: int = (length + places.length() - 1) / places.length()
	var expanded: String = places.repeat(repeats)
	return expanded.substr(expanded.length() - length)


func _value(places: String, values: String) -> int:
	var total: int = 0
	var last_place: int = places.length() - 1
	for index: int in places.length():
		var base: int = places[index].to_int()
		var digit: int = values[index].to_int()
		total += digit * _pow(base, last_place - index)
	return total


func _line_value(line: String, repeat_places: bool) -> int:
	var parts: PackedStringArray = line.split(" ", false)
	var places: String = parts[0].split("-")[1]
	var values: String = parts[1]
	if repeat_places:
		places = _expanded_places(places, values.length())
	return _value(places, values)

# Validator function for part3
# Brute force.  If I get the same value using a smaller number 
# Then this is invalid
func _is_smallest(places: String, values: String, target: int) -> bool:
	var limit: int = values.to_int()
	var candidate: int = 0
	while candidate < limit:
		var text: String = str(candidate)
		if _value(_expanded_places(places, text.length()), text) == target:
			return false
		candidate += 1
	return true


func _total(data: String, repeat_places: bool) -> int:
	var total: int = 0
	for line: String in ECodes.string_to_lines(data):
		if line.is_empty():
			continue
		total += _line_value(line, repeat_places)
	return total


func part1(data: String) -> String:
	return str(_total(data, false))


func part2(data: String) -> String:
	return str(_total(data, true))


func part3(data: String) -> String:
	var total: int = 0
	for line: String in ECodes.string_to_lines(data):
		if line.is_empty():
			continue
		var parts: PackedStringArray = line.split(" ", false)
		var places: String = parts[0].split("-")[1]
		var values: String = parts[1]
		var amount: int = _value(_expanded_places(places, values.length()), values)
		if _is_smallest(places, values, amount):
			total += amount
	return str(total)
