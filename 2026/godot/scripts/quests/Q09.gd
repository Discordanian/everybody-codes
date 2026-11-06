class_name Q09 extends RefCounted

func part1(data: String) -> String:
	return str(_total(data, false))


func part2(data: String) -> String:
	return str(_total(data, true))


func part3(data: String) -> String:
	return str(data.length())


func _total(data: String, count_leaves: bool) -> int:
	var total: int = 0
	for line: String in ECodes.string_to_lines(data.strip_edges()):
		if line.is_empty():
			continue
		var fields: PackedStringArray = line.split(", ", false)
		var growth: int = fields[1].trim_prefix("growth=").to_int()
		var limit: int = fields[2].trim_prefix("limit=").to_int()
		total += _seconds(growth, limit, count_leaves)
	return total


# One branch starts at length 0. Each second every branch grows by one.
# A branch that reaches the odd growth length splits at its middle element.
# That element becomes a branching point, the two halves stay, and a new branch of length 1 appears.
# Part 1 stops on the number of elements. Part 2 stops on leaves: the first tip, plus one for every split.
func _seconds(growth: int, limit: int, count_leaves: bool) -> int:
	var counts: PackedInt64Array = PackedInt64Array()
	counts.resize(growth)
	counts[0] = 1
	var junctions: int = 0
	var measure: int = 0
	var seconds: int = 0
	var half: int = growth / 2
	while measure < limit:
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
		if count_leaves:
			measure = 1 + junctions
		else:
			measure = junctions
			for length: int in growth:
				measure += length * counts[length]
	return seconds
