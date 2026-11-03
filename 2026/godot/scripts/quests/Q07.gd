class_name Q07 extends RefCounted

const IMPULSE: int = 5

func part1(data: String) -> String:
	var energy: Dictionary[int, int] = {}
	var links: Dictionary[int, Array] = {}
	_parse(data, energy, links)
	_spread(energy, links, _busiest(links), IMPULSE)
	return str(_total(energy))


func part2(data: String) -> String:
	return str(data.length())


func part3(data: String) -> String:
	return str(data.length())


func _parse(data: String, energy: Dictionary[int, int], links: Dictionary[int, Array]) -> void:
	for line: String in ECodes.string_to_lines(data.replace("\r", "").strip_edges()):
		if line.is_empty():
			continue
		var fields: PackedStringArray = line.split(", ", false)
		var id: int = fields[0].trim_prefix("id=").to_int()
		var amount: int = fields[1].trim_prefix("energy=").to_int()
		var outs: Array[int] = []
		var tail: String = fields[2].trim_prefix("connections=")
		if not tail.is_empty():
			for token: String in tail.split(",", false):
				outs.append(token.strip_edges().to_int())
		energy[id] = amount
		links[id] = outs


# The cloud with the most outgoing connections. A tie keeps the lowest id.
func _busiest(links: Dictionary[int, Array]) -> int:
	var start: int = 0
	var best: int = -1
	for id: int in links:
		var count: int = links[id].size()
		if count > best or (count == best and id < start):
			best = count
			start = id
	return start


# Each arrival adds its strength. Strength above 1 continues, one weaker, on every outgoing link.
func _spread(energy: Dictionary[int, int], links: Dictionary[int, Array], start: int, strength: int) -> void:
	var queue: Array[Vector2i] = [Vector2i(start, strength)]
	var head: int = 0
	while head < queue.size():
		var here: Vector2i = queue[head]
		head += 1
		var id: int = here.x
		var power: int = here.y
		energy[id] = energy.get(id, 0) + power
		if power <= 1:
			continue
		if not links.has(id):
			continue
		for next: int in links[id]:
			queue.append(Vector2i(next, power - 1))


func _total(energy: Dictionary[int, int]) -> int:
	var sum: int = 0
	for id: int in energy:
		sum += energy[id]
	return sum
