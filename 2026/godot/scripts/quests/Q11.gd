class_name Q11 extends RefCounted

func part1(data: String) -> String:
	var spec: Array = _read(data)
	var count: int = spec[0]
	var chords: Array[Vector2i] = spec[1]
	var links: Array = _ring(count, 1)
	_join(links, chords)
	return str(_ring_strain(count) - _strain(links))


func part2(data: String) -> String:
	var spec: Array = _read(data)
	var count: int = spec[0]
	var chords: Array[Vector2i] = spec[1]
	var plain: int = _strain(_ring(count, 3))
	var links: Array = _ring(count, 3)
	_join(links, chords)
	var dist: Array = _matrix(links)
	var best: int = _strain(links)
	for u: int in count:
		for v: int in range(u + 1, count):
			best = mini(best, _with_crystal(dist, u, v))
	return str(plain - best)


func part3(data: String) -> String:
	var spec: Array = _read(data)
	var count: int = spec[0]
	var chords: Array[Vector2i] = spec[1]
	var plain: int = _strain(_ring(count, 3))
	var best: int = plain
	@warning_ignore("integer_division")
	var gap: int = count / 8
	for start: int in gap:
		var places: Array[int] = []
		for i: int in 8:
			places.append((start + i * gap) % count)
		var scored: Array = [best]
		_pair(places, 0, [], count, chords, scored)
		best = scored[0]
	return str(plain - best)


func _read(data: String) -> Array:
	var count: int = 0
	var chords: Array[Vector2i] = []
	for line: String in ECodes.string_to_lines(data.strip_edges()):
		if line.is_empty():
			continue
		if line.begins_with("portals:"):
			count = line.trim_prefix("portals:").strip_edges().to_int()
			continue
		var ends: PackedStringArray = line.split(" ", false)
		chords.append(Vector2i(ends[0].to_int() - 1, ends[1].to_int() - 1))
	return [count, chords]


func _ring(count: int, span: int) -> Array:
	var links: Array = []
	links.resize(count)
	for i: int in count:
		var nbrs: Array[int] = []
		for step: int in range(1, span + 1):
			nbrs.append((i + step) % count)
			nbrs.append((i + count - step) % count)
		links[i] = nbrs
	return links


func _join(links: Array, chords: Array[Vector2i]) -> void:
	for chord: Vector2i in chords:
		links[chord.x].append(chord.y)
		links[chord.y].append(chord.x)


# Sum of ring distances from every portal to every other portal. Neighbours only.
func _ring_strain(count: int) -> int:
	@warning_ignore("integer_division")
	var half: int = count / 2
	if count % 2 == 0:
		return count * half * half
	return count * half * (half + 1)


# Sum of shortest paths on the given links.
func _strain(links: Array) -> int:
	var total: int = 0
	var dist: Array = _matrix(links)
	for row: PackedInt32Array in dist:
		for step: int in row:
			total += step
	return total


func _matrix(links: Array) -> Array:
	var rows: Array = []
	for start: int in links.size():
		var dist: PackedInt32Array = PackedInt32Array()
		dist.resize(links.size())
		dist.fill(-1)
		dist[start] = 0
		var queue: Array[int] = [start]
		var head: int = 0
		while head < queue.size():
			var here: int = queue[head]
			head += 1
			for nxt: int in links[here]:
				if dist[nxt] >= 0:
					continue
				dist[nxt] = dist[here] + 1
				queue.append(nxt)
		rows.append(dist)
	return rows


# Strain after one extra two-way link is tuned between two portals.
func _with_crystal(dist: Array, u: int, v: int) -> int:
	var total: int = 0
	var count: int = dist.size()
	for a: int in count:
		var row: PackedInt32Array = dist[a]
		var through_u: int = row[u]
		var through_v: int = row[v]
		for b: int in count:
			if a == b:
				continue
			var other: PackedInt32Array = dist[b]
			var via: int = mini(through_u + 1 + other[v], through_v + 1 + other[u])
			total += mini(row[b], via)
	return total


# Eight crystals sit equally spaced. Every way of pairing them into four links is scored.
func _pair(places: Array[int], used: int, edges: Array[Vector2i], count: int, chords: Array[Vector2i], best: Array) -> void:
	var first: int = -1
	for i: int in 8:
		if (used & (1 << i)) == 0:
			first = i
			break
	if first < 0:
		var links: Array = _ring(count, 3)
		_join(links, chords)
		_join(links, edges)
		best[0] = mini(best[0], _strain(links))
		return
	for other: int in range(first + 1, 8):
		if (used & (1 << other)) != 0:
			continue
		edges.append(Vector2i(places[first], places[other]))
		_pair(places, used | (1 << first) | (1 << other), edges, count, chords, best)
		edges.pop_back()
