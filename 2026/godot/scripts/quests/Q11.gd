class_name Q11 extends RefCounted

func part1(data: String) -> String:
	var count: int = 0
	var links: Array = []
	for line: String in ECodes.string_to_lines(data.strip_edges()):
		if line.is_empty():
			continue
		if line.begins_with("portals:"):
			count = line.trim_prefix("portals:").strip_edges().to_int()
			links.resize(count)
			for i: int in count:
				var nbrs: Array[int] = []
				nbrs.append((i + 1) % count)
				nbrs.append((i + count - 1) % count)
				links[i] = nbrs
			continue
		var ends: PackedStringArray = line.split(" ", false)
		var a: int = ends[0].to_int() - 1
		var b: int = ends[1].to_int() - 1
		links[a].append(b)
		links[b].append(a)
	return str(_ring_strain(count) - _strain(links))


func part2(data: String) -> String:
	return str(data.length())


func part3(data: String) -> String:
	return str(data.length())


# Sum of ring distances from every portal to every other portal.
func _ring_strain(count: int) -> int:
	@warning_ignore("integer_division")
	var half: int = count / 2
	if count % 2 == 0:
		return count * half * half
	return count * half * (half + 1)


# Sum of shortest paths once the shortcuts are open.
func _strain(links: Array) -> int:
	var total: int = 0
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
				total += dist[nxt]
				queue.append(nxt)
	return total
