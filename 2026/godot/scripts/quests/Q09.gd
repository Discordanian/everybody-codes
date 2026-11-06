class_name Q09 extends RefCounted

func part1(data: String) -> String:
	var total: int = 0
	for line: String in ECodes.string_to_lines(data.replace("\r", "").strip_edges()):
		if line.is_empty():
			continue
		var fields: PackedStringArray = line.split(", ", false)
		var growth: int = fields[1].trim_prefix("growth=").to_int()
		var limit: int = fields[2].trim_prefix("limit=").to_int()
		total += _seconds(growth, limit)
	return str(total)


func part2(data: String) -> String:
	return str(data.length())


func part3(data: String) -> String:
	return str(data.length())


# One branch starts at length 0. Each second every branch grows by one.
# A branch that reaches the odd growth length splits at its middle element.
# That element becomes a branching point, the two halves stay, and a new branch of length 1 appears.
func _seconds(growth: int, limit: int) -> int:
	var counts: PackedInt64Array = PackedInt64Array()
	counts.resize(growth)
	counts[0] = 1
	var junctions: int = 0
	var size: int = 0
	var seconds: int = 0
	var half: int = growth / 2
	while size < limit:
		seconds += 1
		var splits: int = counts[growth - 1]
		var nxt: PackedInt64Array = PackedInt64Array()
		nxt.resize(growth)
		for length: int in range(growth - 1):
			nxt[length + 1] = counts[length]
		nxt[half] += splits * 2
		nxt[1] += splits
		junctions += splits
		counts = nxt
		size = junctions
		for length: int in growth:
			size += length * counts[length]
	return seconds
