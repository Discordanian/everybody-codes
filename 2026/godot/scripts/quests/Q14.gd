class_name Q14 extends RefCounted

func part1(data: String) -> String:
	return str(_bindings(data))


func part2(data: String) -> String:
	return str(_minimum_bindings(data))


func part3(data: String) -> String:
	return str(_charged_bindings(data))



func _bindings(data: String) -> int:
	var grid: Array[Array] = ECodes.string_to_2d_char_array(data.strip_edges())
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	var rows: int = size.x
	var cols: int = size.y
	var bindings: int = 0
	for y: int in rows:
		for x: int in cols:
			var piece: String = grid[y][x]
			if x == 0 or grid[y][x - 1] != piece:
				bindings += 1
			if y == 0 or grid[y - 1][x] != piece:
				bindings += 1
	return bindings + rows + cols


# Use UnionFind with Kruskal's algorithm to find the minimum spanning tree.
func _minimum_bindings(data: String) -> int:
	var grid: Array[Array] = ECodes.string_to_2d_char_array(data.strip_edges())
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	var rows: int = size.x
	var cols: int = size.y
	var ids: Dictionary = {}
	for y: int in rows:
		for x: int in cols:
			var piece: String = grid[y][x]
			if not ids.has(piece):
				ids[piece] = ids.size()
	var frame: int = ids.size()
	var frame_cost: PackedInt32Array = PackedInt32Array()
	frame_cost.resize(frame)
	var seams: Dictionary = {}
	for y: int in rows:
		for x: int in cols:
			var here: int = ids[grid[y][x]]
			if y == 0:
				frame_cost[here] += 1
			if y == rows - 1:
				frame_cost[here] += 1
			if x == 0:
				frame_cost[here] += 1
			if x == cols - 1:
				frame_cost[here] += 1
			if x + 1 < cols:
				_add_seam(seams, here, ids[grid[y][x + 1]])
			if y + 1 < rows:
				_add_seam(seams, here, ids[grid[y + 1][x]])
	var edges: Array[Vector3i] = _seam_edges(seams, frame_cost, frame)
	return _span(edges, frame + 1, -1, -1)


# Choose the two charged pieces that leave the smallest
# remaining spanning tree.
func _charged_bindings(data: String) -> int:
	var grid: Array[Array] = ECodes.string_to_2d_char_array(data.strip_edges())
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	var rows: int = size.x
	var cols: int = size.y
	var ids: Dictionary = {}
	for y: int in rows:
		for x: int in cols:
			var piece: String = grid[y][x]
			if not ids.has(piece):
				ids[piece] = ids.size()
	var frame: int = ids.size()
	var frame_cost: PackedInt32Array = PackedInt32Array()
	frame_cost.resize(frame)
	var seams: Dictionary = {}
	for y: int in rows:
		for x: int in cols:
			var here: int = ids[grid[y][x]]
			if y == 0:
				frame_cost[here] += 1
			if y == rows - 1:
				frame_cost[here] += 1
			if x == 0:
				frame_cost[here] += 1
			if x == cols - 1:
				frame_cost[here] += 1
			if x + 1 < cols:
				_add_seam(seams, here, ids[grid[y][x + 1]])
			if y + 1 < rows:
				_add_seam(seams, here, ids[grid[y + 1][x]])
	var edges: Array[Vector3i] = _seam_edges(seams, frame_cost, frame)
	var best: int = _span(edges, frame + 1, 0, 1)
	for left: int in frame:
		for right: int in range(left + 1, frame):
			var bindings: int = _span(edges, frame + 1, left, right)
			if bindings < best:
				best = bindings
	return best


func _seam_edges(seams: Dictionary, frame_cost: PackedInt32Array, frame: int) -> Array[Vector3i]:
	var edges: Array[Vector3i] = []
	for link: Vector2i in seams:
		edges.append(Vector3i(seams[link], link.x, link.y))
	for piece: int in frame:
		if frame_cost[piece] > 0:
			edges.append(Vector3i(frame_cost[piece], piece, frame))
	edges.sort_custom(_cheaper_seam)
	return edges


func _span(edges: Array[Vector3i], nodes: int, charged_a: int, charged_b: int) -> int:
	var forest: UnionFind = UnionFind.new(nodes)
	if charged_a >= 0:
		for edge: Vector3i in edges:
			if edge.y == charged_a or edge.z == charged_a or edge.y == charged_b or edge.z == charged_b:
				forest.unite(edge.y, edge.z)
	var bindings: int = 0
	for edge: Vector3i in edges:
		if forest.same(edge.y, edge.z):
			continue
		forest.unite(edge.y, edge.z)
		bindings += edge.x
	return bindings


func _add_seam(seams: Dictionary, left: int, right: int) -> void:
	if left == right:
		return
	var link: Vector2i = Vector2i(mini(left, right), maxi(left, right))
	seams[link] = int(seams.get(link, 0)) + 1


func _cheaper_seam(left: Vector3i, right: Vector3i) -> bool:
	return left.x < right.x
