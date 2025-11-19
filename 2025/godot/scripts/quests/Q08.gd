class_name Q08 extends RefCounted

static func _sum_exclusive(links: Array, left: int, right: int) -> int:
	var retval: int = 0
	for l: int in links:
		if left < l and l < (right - 1):
			retval += 1
	return retval

static func _sum_inclusive(links: Array, left: int, right: int) -> int:
	var retval: int = 0
	for l: int in links:
		if not (left <= l and l <= right):
			retval += 1
	return retval

static func _overlaps(a: Vector2i, b: Vector2i) -> bool:
	var s1: int = a.x
	var e1: int = a.y
	var s2: int = b.x
	var e2: int = b.y

	var case1: bool = (s2 > s1 and s2 < e1 and (e2> e1 or e2 < s1))
	var case2: bool = (e2 > s1 and e2 < e1 and (s2 > e1 or s2 < s1))
	var same_forward: bool = (s1 == s2 and e1 == e2)
	var same_reverse: bool = (s2 == e1 and e2 == s1)

	return case1 or case2 or same_forward or same_reverse


static func part1(data: String) -> String:
	var sequence: Array[int] = ECodes.array_int_from_string(data)
	var pins: int = 32
	if debug:
		pins = 8
	var mid: int = pins/2
	var count: int = 0
	for idx: int in range(sequence.size() - 1):
		if mid == abs(sequence[idx] - sequence[idx+1]):
			count += 1
	return str(count)


static func part2(data: String) -> String:
	var sequence: Array[int] = ECodes.array_int_from_string(data)
	var links: Array[Vector2i] = []

	for idx: int in range(sequence.size() - 1):
		var start: int = min(sequence[idx], sequence[idx+1])
		var end: int = max(sequence[idx], sequence[idx+1])
		links.append(Vector2i(start,end))

	var seen: Array[Vector2i] = []
	var retval: int = 0
	for curr: Vector2i in links:
		var count: int = 0
		for prev: Vector2i in seen:
			if _overlaps(curr, prev):
				count += 1
		retval += count
		seen.append(curr)

	return str(retval)


static func part3(data: String) -> String:
	var sequence: Array[int] = ECodes.array_int_from_string(data)
	var pins: int = 256
	var retval: int = 0
	if debug:
		pins = 8

	var links: Dictionary = {}
	for key: int in range(pins):
		links[key+1] = []

	for pin: int in range(sequence.size() - 1):
		var key1: int = sequence[pin]
		var key2: int = sequence[pin + 1]
		links[key1].append(key2)
		links[key2].append(key1)

	for left: int in range(1,pins+1):
		var cuts: int = 0
		for right: int in range(left+2, pins+1):
			cuts -= _sum_exclusive(links[right], left, right-1)
			cuts += _sum_inclusive(links[right-1], left, right)
			retval = max(retval, cuts + links[left].count(right))


	return str(retval)
