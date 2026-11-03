class_name Q07 extends RefCounted

const IMPULSE_1: int = 5
const IMPULSE_2: int = 10
const EXPLOSION: int = 1000000

func part1(data: String) -> String:
	return str(_charge(data, IMPULSE_1))


func part2(data: String) -> String:
	return str(_charge(data, IMPULSE_2))


func part3(data: String) -> String:
	var energy: Dictionary[int, int] = {}
	var links: Dictionary[int, Array] = {}
	_parse(data, energy, links)
	var best: int = 0
	for id: int in energy:
		best = maxi(best, _remaining(energy, links, id, IMPULSE_2, EXPLOSION))
	return str(best)


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


func _charge(data: String, strength: int) -> int:
	var energy: Dictionary[int, int] = {}
	var links: Dictionary[int, Array] = {}
	_parse(data, energy, links)
	_spread(energy, links, _busiest(links), strength)
	return _total(energy)


func _spread(energy: Dictionary[int, int], links: Dictionary[int, Array], start: int, strength: int) -> void:
	var counts: Dictionary[int, int] = {start: 1}
	var power: int = strength
	while power > 0 and not counts.is_empty():
		var nxt: Dictionary[int, int] = {}
		for id: int in counts:
			var n: int = counts[id]
			energy[id] = energy.get(id, 0) + power * n
			if power == 1 or not links.has(id):
				continue
			for next: int in links[id]:
				nxt[next] = nxt.get(next, 0) + n
		counts = nxt
		power -= 1


func _total(energy: Dictionary[int, int]) -> int:
	var sum: int = 0
	for id: int in energy:
		sum += energy[id]
	return sum


func _remaining(initial: Dictionary[int, int], links: Dictionary[int, Array], start: int, strength: int, limit: int) -> int:
	var energy: Dictionary[int, int] = {}
	var alive: Dictionary[int, bool] = {}
	for id: int in initial:
		energy[id] = initial[id]
		alive[id] = true
	var pending: Dictionary[int, Array] = {}
	_add(pending, start, strength, 1)
	while not pending.is_empty():
		var emitted: Dictionary[int, Array] = {}
		for id: int in pending:
			if not alive.get(id, false):
				continue
			var got: Array = pending[id]
			for power: int in range(1, strength + 1):
				var n: int = got[power]
				if n == 0:
					continue
				energy[id] += power * n
				if power == 1 or not links.has(id):
					continue
				for next: int in links[id]:
					_add(emitted, next, power - 1, n)
		for id: int in initial:
			if not alive[id] or energy[id] < limit:
				continue
			alive[id] = false
			if not links.has(id):
				continue
			for next: int in links[id]:
				_add(emitted, next, strength, 1)
		pending = emitted
	var total: int = 0
	for id: int in energy:
		if alive[id]:
			total += energy[id]
	return total


func _add(bucket: Dictionary[int, Array], id: int, power: int, n: int) -> void:
	if not bucket.has(id):
		var counts: Array[int] = []
		counts.resize(11)
		bucket[id] = counts
	var row: Array = bucket[id]
	row[power] += n
