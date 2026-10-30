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

# Each line of input is a part for a given id, so just counting
# times I see each id and using that in custom sort.
func part2(data: String) -> String:
	var counts: Dictionary[int, int] = {}
	var totals: Dictionary[int, int] = {}
	for line: String in ECodes.string_to_lines(data):
		if line.is_empty():
			continue
		var numbers: Array[int] = ECodes.array_int_from_string(line)
		var id: int = numbers[0]
		var time: int = numbers[3]
		if not totals.has(id):
			counts[id] = 0
			totals[id] = 0
		counts[id] += 1
		totals[id] += time
	var ids: Array[int] = []
	for id: int in totals:
		ids.append(id)
	ids.sort_custom(func(left: int, right: int) -> bool:
		if counts[left] != counts[right]:
			return counts[left] > counts[right]
		return totals[left] < totals[right]
	)
	var checksum: int = 0
	for index: int in ids.size():
		checksum += (index + 1) * totals[ids[index]]
	return str(checksum)


func _attempt_key(quest: int, id: int, part: int) -> String:
	return "%d:%d:%d" % [quest, id, part]


func _cumulative_time(times: Dictionary[String, int], quest: int, id: int, part: int) -> int:
	var total: int = 0
	for earlier: int in range(1, part + 1):
		var key: String = _attempt_key(quest, id, earlier)
		if not times.has(key):
			return -1
		total += times[key]
	return total


func _part_points(rank: int, part: int) -> int:
	var points: int = part * 50 - rank + 1
	if points < 0:
		return 0
	return points


func part3(data: String) -> String:
	var times: Dictionary[String, int] = {}
	var quest_parts: Dictionary[int, int] = {}
	var scores: Dictionary[int, int] = {}
	for line: String in ECodes.string_to_lines(data):
		if line.is_empty():
			continue
		var numbers: Array[int] = ECodes.array_int_from_string(line)
		var id: int = numbers[0]
		var quest: int = numbers[1]
		var part: int = numbers[2]
		var time: int = numbers[3]
		times[_attempt_key(quest, id, part)] = time
		if not quest_parts.has(quest) or part > quest_parts[quest]:
			quest_parts[quest] = part
		if not scores.has(id):
			scores[id] = 0
	for quest: int in quest_parts:
		for part: int in range(1, quest_parts[quest] + 1):
			var cumulative: Dictionary[int, int] = {}
			var finishers: Array[int] = []
			for id: int in scores:
				var total_time: int = _cumulative_time(times, quest, id, part)
				if total_time < 0:
					continue
				cumulative[id] = total_time
				finishers.append(id)
			finishers.sort_custom(func(left: int, right: int) -> bool:
				return cumulative[left] < cumulative[right]
			)
			var index: int = 0
			while index < finishers.size():
				var total_time: int = cumulative[finishers[index]]
				var next: int = index + 1
				while next < finishers.size() and cumulative[finishers[next]] == total_time:
					next += 1
				var points: int = _part_points(index + 1, part)
				for tied: int in range(index, next):
					scores[finishers[tied]] += points
				index = next
	var ranked: Array[int] = []
	for id: int in scores:
		ranked.append(id)
	ranked.sort_custom(func(left: int, right: int) -> bool:
		return scores[left] > scores[right]
	)
	var checksum: int = 0
	var index: int = 0
	while index < ranked.size():
		var score: int = scores[ranked[index]]
		var next: int = index + 1
		while next < ranked.size() and scores[ranked[next]] == score:
			next += 1
		checksum += (index + 1) * score * (next - index)
		index = next
	return str(checksum)
