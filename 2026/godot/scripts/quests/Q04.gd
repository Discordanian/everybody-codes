class_name Q04 extends RefCounted

func part1(data: String) -> String:
	var totals: Dictionary[int, int] = {}
	for line: String in ECodes.string_to_lines(data):
		if line.is_empty():
			continue
		var numbers: Array[int] = ECodes.array_int_from_string(line)
		var id: int = numbers[0]
		var time: int = numbers[3]
		if not totals.has(id):
			totals[id] = 0
		totals[id] += time
	var sums: Array[int] = []
	for id: int in totals:
		sums.append(totals[id])
	sums.sort()
	var checksum: int = 0
	for index: int in sums.size():
		checksum += (index + 1) * sums[index]
	return str(checksum)


func part2(data: String) -> String:
	return str(data.length())


func part3(data: String) -> String:
	return str(data.length())
