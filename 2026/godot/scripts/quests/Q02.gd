class_name Q02 extends RefCounted

func _line_number(line: String) -> int:
	var before: Dictionary[int, Array] = {}
	var indegree: Dictionary[int, int] = {}
	for token: String in line.split(" ", false):
		var numbers: Array[int] = ECodes.array_int_from_string(token)
		var left: int = numbers[0]
		var right: int = numbers[1]
		var greater: int = left if token.contains(">") else right
		var lesser: int = right if token.contains(">") else left
		_add_digit(before, indegree, greater)
		_add_digit(before, indegree, lesser)
		if not before[greater].has(lesser):
			before[greater].append(lesser)
			indegree[lesser] += 1
	var ready: Array[int] = []
	for digit: int in indegree:
		if indegree[digit] == 0:
			ready.append(digit)
	var order: String = ""
	while not ready.is_empty():
		var current: int = ready.pop_front()
		order += str(current)
		for later: int in before[current]:
			indegree[later] -= 1
			if indegree[later] == 0:
				ready.append(later)
	return order.to_int()


func _add_digit(before: Dictionary[int, Array], indegree: Dictionary[int, int], digit: int) -> void:
	if not before.has(digit):
		before[digit] = []
		indegree[digit] = 0


func part1(data: String) -> String:
	var total: int = 0
	for line: String in ECodes.string_to_lines(data):
		if line.is_empty():
			continue
		total += _line_number(line)
	return str(total)


func part2(data: String) -> String:
	return str(data.length())


func part3(data: String) -> String:
	return str(data.length())
