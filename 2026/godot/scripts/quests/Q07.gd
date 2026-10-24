class_name Q07 extends RefCounted

static func _combinations(puzzle_name: String, rules: Dictionary) -> Array[String]:
	if puzzle_name.length() == 11:
		return [puzzle_name]

	var last_char: String = puzzle_name[puzzle_name.length() - 1]
	var letters: Array = rules.get(last_char, [])

	if letters.is_empty():
		return [puzzle_name]

	var result: Array[String] = [puzzle_name]

	for c: String in letters:
		var new_puzzle_name: String = puzzle_name + c
		var recursive_results: Array[String] = _combinations(new_puzzle_name, rules)
		for r: String in recursive_results:
			if not result.has(r):
				result.append(r)

	return result

static func _valid_puzzle_name(n: String, map: Dictionary) -> bool:
	for idx: int in range(n.length() - 1):
		var key: String = n[idx]
		var target: String = n[idx + 1]
		if not map.has(key):
			return false
		if not map[key].has(target):
			return false
	return true

static func _number_possible(n: String, map: Dictionary) -> int:
	if not _valid_puzzle_name(n, map):
		return 0
	if n.length() > 11:
		return 0
	var last_letter: String = n[n.length() - 1]
	if not map.has(last_letter):
		return 0
	var extra: PackedStringArray = map[last_letter]
	var sum: int = 0
	for c: String in extra:
		var dance_mix_puzzle_name: String = n + c
		sum += _number_possible(dance_mix_puzzle_name, map)
	if n.length() > 6:
		sum += extra.size()
	return sum


static func part1(data: String) -> String:
	var lines: PackedStringArray = ECodes.string_to_lines(data.strip_edges())
	var puzzle_names: PackedStringArray = lines[0].split(",")
	var retval: String = ""
	var map: Dictionary = {}
	for i: int in range(lines.size()):
		if i < 2:
			continue
		var arrow: PackedStringArray = lines[i].split(" > ")
		var key: String = arrow[0]
		var val: PackedStringArray = arrow[1].split(",")
		map[key] = val
	for n: String in puzzle_names:
		if _valid_puzzle_name(n, map):
			retval = n
	return retval


static func part2(data: String) -> String:
	var lines: PackedStringArray = ECodes.string_to_lines(data.strip_edges())
	var puzzle_names: PackedStringArray = lines[0].split(",")
	var retval: int = 0
	var map: Dictionary = {}
	for i: int in range(lines.size()):
		if i < 2:
			continue
		var arrow: PackedStringArray = lines[i].split(" > ")
		var key: String = arrow[0]
		var val: PackedStringArray = arrow[1].split(",")
		map[key] = val
	for idx: int in range(puzzle_names.size()):
		if _valid_puzzle_name(puzzle_names[idx], map):
			retval += (1 + idx)

	return str(retval)


static func part3(data: String) -> String:
	var lines: PackedStringArray = ECodes.string_to_lines(data.strip_edges())
	var puzzle_names: PackedStringArray = lines[0].split(",")
	var map: Dictionary = {}
	var puzzle_name_set: Set = Set.new()
	var q: Array[String] = []
	var seen: Array[String] = []
	for i: int in range(lines.size()):
		if i < 2:
			continue
		var arrow: PackedStringArray = lines[i].split(" > ")
		var key: String = arrow[0]
		var val: PackedStringArray = arrow[1].split(",")
		map[key] = val


	for n: String in puzzle_names:
		if _valid_puzzle_name(n, map):
			q.append(n)

	while not q.is_empty():
		var n: String = q.pop_front()
		if seen.has(n):
			continue
		if n.length() > 11:
			continue
		seen.append(n)
		if n.length() > 6:
			puzzle_name_set.add(n)
		var last_char: String = n[n.length() - 1]
		if map.has(last_char):
			for next: String in map[last_char]:
				q.append(n + next)
	return str(puzzle_name_set.size())

static func part3p(data: String, ans: LineEdit) -> void:
	var lines: PackedStringArray = ECodes.string_to_lines(data.strip_edges())
	var puzzle_names: PackedStringArray = lines[0].split(",")

	# Parse rules into Dictionary where key is String and value is Array[String]
	var map: Dictionary = {}

	for i: int in range(lines.size()):
		if i < 2:
			continue
		var arrow: PackedStringArray = lines[i].split(" > ")
		var key: String = arrow[0]
		var val: PackedStringArray = arrow[1].split(",")
		map[key] = val

	# Build result set (using Array as Set equivalent)
	var res: Array[String] = []

	for puzzle_name: String in puzzle_names:
		# Check if puzzle_name follows the rules
		var valid: bool = true
		for i: int in range(puzzle_name.length() - 1):
			var current_char: String = puzzle_name[i]
			var next_char: String = puzzle_name[i + 1]

			var rule_chars: Array = map.get(current_char, [])
			if not rule_chars.has(next_char):
				valid = false
				break

		if valid:
			var combo_results: Array[String] = _combinations(puzzle_name, map)
			for r: String in combo_results:
				if not res.has(r):
					res.append(r)

	# Count results with length >= 7
	var count: int = 0
	for r: String in res:
		if r.length() >= 7:
			count += 1

	return str(count)
