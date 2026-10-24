class_name Q14 extends RefCounted

# Assume that grid isn't needed in the return
# @param active Set the set of active nodes
# @param grid Set just a set of every node in the grid
static func _round(active: Set, grid: Set) -> Set:
	var diags: Array[Vector2i] = [ Vector2i(1,1), Vector2i(-1,-1), Vector2i(1,-1), Vector2i(-1,1)]
	var next_active: Set = Set.new()
	var diag_count: int = 0
	for v: Vector2i in grid:
		diag_count = 0
		for d: Vector2i in diags:
			if active.contains(v + d):
				diag_count += 1
		if active.contains(v) and diag_count % 2 == 1:
			next_active.add(v)
		if not active.contains(v) and diag_count % 2 == 0:
			next_active.add(v)
	return next_active
                 
 

static func sim(active: Dictionary, n: int) -> Dictionary:
	var result: Dictionary = {}
	for r:int in range(n):
		for c: int in range(n):
			var active_diags: int = 0
			for offset: Vector2i in [Vector2i(-1, -1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(1, 1)]:
				var r2: int = r + offset.x
				var c2: int = c + offset.y
				if active.has(Vector2i(r2, c2)):
					active_diags += 1
			var pos : Vector2i = Vector2i(r, c)
			if active.has(pos):
				if active_diags % 2 == 1:
					result[pos] = true
			else:
				if active_diags % 2 == 0:
					result[pos] = true
	return result
    
static func does_match_pattern(active: Dictionary, lines: Array[String]) -> bool:
	var r_start: int = 13
	var c_start: int = 13
	for dr: int in range(lines.size()):
		for dc: int in range(lines[0].length()):
			var r: int = r_start + dr
			var c: int = c_start + dc
			var pos :Vector2i = Vector2i(r, c)
			if lines[dr][dc] == "#":
				if not active.has(pos):
					return false
			else:
				if active.has(pos):
					return false
	return true

static func sum_func(a: int, b: int) -> int:
	return a + b       
        
        

static func part1(data: String) -> String:
	var lines: PackedStringArray = ECodes.string_to_lines(data.strip_edges())
	var grid: Set = Set.new()
	var active: Set = Set.new()
	for y: int in range(lines.size()):
		for x: int in range(lines[y].length()):
			var v: Vector2i = Vector2i(x,y)
			grid.add(v)
			if lines[y][x] == "#":
				active.add(v)
	var sum: int = 0            
	for _r: int in range(10):
		active = _round(active, grid)
		sum += active.size()
    
    
	return str(sum)
    

static func part2(data: String) -> String:
	var lines: PackedStringArray = ECodes.string_to_lines(data.strip_edges())
	var grid: Set = Set.new()
	var active: Set = Set.new()
	for y: int in range(lines.size()):
		for x: int in range(lines[y].length()):
			var v: Vector2i = Vector2i(x,y)
			grid.add(v)
			if lines[y][x] == "#":
				active.add(v)
	var sum: int = 0            
	for _r: int in range(2025):
		active = _round(active, grid)
		sum += active.size()
    
    
	return str(sum)


static func part3(data: String) -> String:
	var lines: PackedStringArray = data.split("\n", false)
	var n: int = 34

	var active: Dictionary = {}
	var rounds: Array[int] = []
	var active_counts: Array[int] = []
	for rnd: int in range(1, 10000 + 1):
		active = sim(active, n)
		if not does_match_pattern(active, lines):
			continue
		rounds.append(rnd)
		active_counts.append(active.size())
	var first_round: int = rounds[0]
	var round_deltas: Array[int] = []
	var prev: int = 0
	for r: int in rounds:
		round_deltas.append(r - prev)
		prev = r
	var first_active_count: int = active_counts[0]
	var cycle_len: int = round_deltas.slice(1).find(round_deltas[0]) + 1
	round_deltas = round_deltas.slice(0, cycle_len)
	active_counts = active_counts.slice(0, cycle_len)
	var total_round_deltas: int = round_deltas.reduce(sum_func)
	var total_active_counts: int = active_counts.reduce(sum_func)
	var target_round: int = 1000000000
	var times: int = (target_round - first_round) / total_round_deltas
	var answer: int = first_active_count + times * total_active_counts
	var remaining: int = target_round - (first_round + times * total_round_deltas)
	var i: int = 0
	while i < round_deltas.size() and remaining > round_deltas[i]:
		remaining -= round_deltas[i]
		answer += active_counts[i]
		i += 1
	return str(answer)
