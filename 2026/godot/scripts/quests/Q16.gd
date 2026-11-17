class_name Q16 extends RefCounted

func part1(data: String) -> String:
	var total: int = 0
	for line: String in ECodes.string_to_lines(data.strip_edges()):
		if line.is_empty():
			continue
		total += _flips(line)
	return str(total)


func part2(data: String) -> String:
	return str(data.length())


func part3(data: String) -> String:
	return str(data.length())


# Each flip joins the first and last group of the leftmost shade that is still split.
func _flips(shelf: String) -> int:
	var tablets: PackedStringArray = PackedStringArray()
	for index: int in shelf.length():
		tablets.append(shelf[index])
	var flips: int = 0
	while true:
		var shade: String = _split_shade(tablets)
		if shade == "":
			return flips
		_join(tablets, shade)
		flips += 1
	return flips


func _split_shade(tablets: PackedStringArray) -> String:
	var counts: Dictionary = {}
	var order: PackedStringArray = PackedStringArray()
	var index: int = 0
	var count: int = tablets.size()
	while index < count:
		var shade: String = tablets[index]
		var end: int = index + 1
		while end < count and tablets[end] == shade:
			end += 1
		if not counts.has(shade):
			counts[shade] = 0
			order.append(shade)
		counts[shade] = int(counts[shade]) + 1
		index = end
	for shade: String in order:
		if int(counts[shade]) > 1:
			return shade
	return ""


func _join(tablets: PackedStringArray, shade: String) -> void:
	var first_end: int = -1
	var last_end: int = -1
	var index: int = 0
	var count: int = tablets.size()
	while index < count:
		if tablets[index] != shade:
			index += 1
			continue
		var end: int = index + 1
		while end < count and tablets[end] == shade:
			end += 1
		if first_end < 0:
			first_end = end
		last_end = end
		index = end
	var left: int = first_end
	var right: int = last_end - 1
	while left < right:
		var swap: String = tablets[left]
		tablets[left] = tablets[right]
		tablets[right] = swap
		left += 1
		right -= 1
