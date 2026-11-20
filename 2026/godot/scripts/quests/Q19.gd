class_name Q19 extends RefCounted

func part1(data: String) -> String:
	var layers: PackedStringArray = data.strip_edges().split("\n\n")
	var top: Array[Array] = ECodes.string_to_2d_char_array(layers[0])
	var bottom: Array[Array] = ECodes.string_to_2d_char_array(layers[1])
	var size: Vector2i = ECodes.dimensions_of_2d_array(top)
	var counts: Counter = Counter.new()
	for y: int in size.x:
		for x: int in size.y:
			counts.add(_mix(top[y][x], bottom[y][x]))
	return str(_cubes(counts))


func part2(data: String) -> String:
	var layers: PackedStringArray = data.strip_edges().split("\n\n")
	var top: Array[Array] = ECodes.string_to_2d_char_array(layers[0])
	var bottom: Array[Array] = ECodes.string_to_2d_char_array(layers[1])
	var size: Vector2i = ECodes.dimensions_of_2d_array(top)
	var colours: PackedStringArray = PackedStringArray(["C", "M", "Y", "K"])
	var order: Array[int] = [0, 1, 2, 3]
	var best: int = 0
	while true:
		var score: int = _assigned_cubes(top, bottom, size, colours, order)
		if score > best:
			best = score
		if not AoCIter.next_permutation(order):
			break
	return str(best)


func part3(data: String) -> String:
	return str(data.length())


func _assigned_cubes(top: Array[Array], bottom: Array[Array], size: Vector2i, colours: PackedStringArray, order: Array[int]) -> int:
	var counts: Counter = Counter.new()
	for y: int in size.x:
		for x: int in size.y:
			var digit: int = int(bottom[y][x]) - 1
			counts.add(_mix(top[y][x], colours[order[digit]]))
	return _cubes(counts)


func _cubes(counts: Counter) -> int:
	var product: int = 1
	for entry: Array in counts.most_common(3):
		product *= int(entry[1])
	return product


func _mix(first: String, second: String) -> String:
	if first == "K" or second == "K":
		return "K"
	if first == second:
		return first
	var pair: String = first + second if first < second else second + first
	match pair:
		"CM":
			return "B"
		"CY":
			return "G"
		"MY":
			return "R"
	return first
