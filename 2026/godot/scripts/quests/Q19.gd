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
	var tally: Counter = Counter.new()
	for line: String in ECodes.string_to_lines(data.strip_edges()):
		if line.is_empty():
			continue
		for index: int in line.length():
			tally.add(line[index])
	var supplies: PackedInt32Array = PackedInt32Array([
		tally.get_count("C"),
		tally.get_count("M"),
		tally.get_count("Y"),
	])
	var black: int = tally.get_count("K")
	var total: int = supplies[0] + supplies[1] + supplies[2]
	var caps: PackedInt32Array = _reach_caps(supplies)
	var best: int = 0
	for colors: PackedInt32Array in AoCIter.combinations(6, 3):
		if not _routable(colors, supplies):
			continue
		var score: int = _best_split(colors, caps, black, total)
		if score > best:
			best = score
	return str(best)


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


# Colour ids: 0 C, 1 M, 2 Y, 3 B, 4 G, 5 R. 
func _can_reach(supply: int, color: int) -> bool:
	match supply:
		0:
			return color == 0 or color == 3 or color == 4
		1:
			return color == 1 or color == 3 or color == 5
		2:
			return color == 2 or color == 4 or color == 5
	return false


func _reach_caps(supplies: PackedInt32Array) -> PackedInt32Array:
	var caps: PackedInt32Array = PackedInt32Array()
	caps.resize(64)
	for mask: int in 64:
		var capacity: int = 0
		for supply: int in 3:
			var reaches: bool = false
			for color: int in 6:
				if (mask & (1 << color)) != 0 and _can_reach(supply, color):
					reaches = true
					break
			if reaches:
				capacity += supplies[supply]
		caps[mask] = capacity
	return caps


func _routable(colors: PackedInt32Array, supplies: PackedInt32Array) -> bool:
	for supply: int in 3:
		if supplies[supply] == 0:
			continue
		var reaches: bool = false
		for color: int in colors:
			if _can_reach(supply, color):
				reaches = true
				break
		if not reaches:
			return false
	return true


func _best_split(colors: PackedInt32Array, caps: PackedInt32Array, black: int, total: int) -> int:
	var first: int = colors[0]
	var second: int = colors[1]
	var third: int = colors[2]
	var first_mask: int = 1 << first
	var second_mask: int = 1 << second
	var third_mask: int = 1 << third
	var rest_mask: int = second_mask | third_mask
	var first_low: int = maxi(0, total - caps[rest_mask])
	var first_high: int = mini(total, caps[first_mask])
	var best: int = 0
	for count: int in range(first_low, first_high + 1):
		var remain: int = total - count
		if remain > caps[rest_mask]:
			continue
		var low: int = maxi(0, remain - caps[third_mask])
		low = maxi(low, total - caps[first_mask | third_mask])
		var high: int = mini(remain, caps[second_mask])
		high = mini(high, caps[first_mask | second_mask] - count)
		if low > high:
			continue
		@warning_ignore("integer_division")
		var half: int = remain / 2
		var chosen: int = clampi(half, low, high)
		var score: int = _top_product(count, chosen, remain - chosen, black)
		var other: int = clampi(half + 1, low, high)
		if other != chosen:
			score = maxi(score, _top_product(count, other, remain - other, black))
		for edge: int in [low, high, black, remain - black, count, remain - count]:
			if edge < low or edge > high:
				continue
			score = maxi(score, _top_product(count, edge, remain - edge, black))
		if score > best:
			best = score
	return best


func _top_product(first: int, second: int, third: int, black: int) -> int:
	var values: Array[int] = [first, second, third, black]
	values.sort()
	return values[1] * values[2] * values[3]


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
