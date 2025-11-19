class_name Q06 extends RefCounted

static func _is_novice(s: String) -> bool:
	return s.to_lower() == s

static func _mentor_count(source: String, type: String) -> int:
	return source.count(type.to_upper())


static func part1(data: String) -> String:
	var len: int = data.length()
	var mentors: Array[int] = []
	var novices: Array[int] = []
	var retval: int = 0
	for idx: int in range(len):
		if data[idx] == "A":
			mentors.append(idx)
		if data[idx] == "a":
			novices.append(idx)
	for novice: int in novices:
		retval += mentors.filter(func(mentor: int) -> bool: return mentor < novice).size()

	return str(retval)


static func part2(data: String) -> String:
	var retval: int = 0
	for idx: int in range(data.length()):
		var x: String = data[idx]
		if _is_novice(x):
			retval += _mentor_count(data.substr(0, idx),x)

	return str(retval)


static func part3(data: String) -> String:
	const MAP_PERIOD: int = 1000
	const MENTOR_WINDOW: int = 1000

	var retval: int = 0

	# First loop: process first MENTOR_WINDOW characters
	for i:int in range(MENTOR_WINDOW):
		if not data[i].to_upper() == data[i]:
			var lowercase_char: String = data[i]
			var uppercase_char: String = lowercase_char.to_upper()
			var substring: String = data.substr(data.length() - MENTOR_WINDOW + i)
			retval += substring.count(uppercase_char)

		if not data[data.length() - 1 - i].to_upper() == data[data.length() - 1 - i]:
			var lowercase_char: String = data[data.length() - 1 - i]
			var uppercase_char: String = lowercase_char.to_upper()
			var substring: String = data.substr(0, MENTOR_WINDOW - i)
			retval += substring.count(uppercase_char)

	retval *= MAP_PERIOD - 1

	# Second loop: process all characters
	for i:int in range(data.length()):
		if data[i].to_upper() == data[i]:
			continue

		var lowercase_char: String = data[i]
		var uppercase_char: String = lowercase_char.to_upper()
		var start: int = max(0, i - MENTOR_WINDOW)
		var length: int = min(data.length(), i + MENTOR_WINDOW + 1) - start
		var substring: String = data.substr(start, length)
		retval += substring.count(uppercase_char) * MAP_PERIOD

	return str(retval)
