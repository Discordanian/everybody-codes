class_name Q15 extends RefCounted

func part1(data: String) -> String:
	var DIRS: Array[Vector2i] = [Vector2i(-1, 0), Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1)]
	var r: int = 0
	var c: int = 0
	var d: int = 0
    
	var I: Array[Vector2i] = [Vector2i(0, 0)]
	var instructions: PackedStringArray = data.strip_edges().split(',')
    
	for instr: String in instructions:
		var turn: String = instr[0]
		var amt: int = int(instr.substr(1))
        
		if turn == 'R':
			d = (d + 1) % 4
		else:
			d = (d + 3) % 4
        
		r += amt * DIRS[d].x
		c += amt * DIRS[d].y
		I.append(Vector2i(r, c))
    
	# Build coordinate compression maps
	var Rs: Array[int] = []
	var Cs: Array[int] = []
    
	for pos: Vector2i in I:
		Rs.append(pos.x - 1)
		Rs.append(pos.x)
		Rs.append(pos.x + 1)
		Cs.append(pos.y - 1)
		Cs.append(pos.y)
		Cs.append(pos.y + 1)
    

	var Rs_set: Dictionary = {}
	var Cs_set: Dictionary = {}
	for val: int in Rs:
		Rs_set[val] = true
	for val: int in Cs:
		Cs_set[val] = true
    
	Rs.clear()
	Cs.clear()
	for key: Variant in Rs_set.keys():
		Rs.append(key)
	for key: Variant in Cs_set.keys():
		Cs.append(key)
	Rs.sort()
	Cs.sort()
    
	# mappings
	var Rsmall: Dictionary = {}  
	var Csmall: Dictionary = {}
	var Rbig: Dictionary = {}   
	var Cbig: Dictionary = {}
    
	for i:int in range(Rs.size()):
		Rsmall[Rs[i]] = i
		Rbig[i] = Rs[i]
	for i:int in range(Cs.size()):
		Csmall[Cs[i]] = i
		Cbig[i] = Cs[i]


	r = 0
	c = 0
	d = 0
	var WALL: Dictionary = {}  
    
	for instr: String in instructions:
		var turn: String = instr[0]
		var amt: int = int(instr.substr(1))
        
		if turn == 'R':
			d = (d + 1) % 4
		else:
			d = (d + 3) % 4
        
		var old_r: int = Rsmall[r]
		var old_c: int = Csmall[c]
        
		r += amt * DIRS[d].x
		c += amt * DIRS[d].y
        
		var new_r: int = Rsmall[r]
		var new_c: int = Csmall[c]
        
		for rr: int in range(mini(old_r, new_r), maxi(old_r, new_r) + 1):
			for cc: int in range(mini(old_c, new_c), maxi(old_c, new_c) + 1):
				WALL[Vector2i(rr, cc)] = true
    
	var er: int = r
	var ec: int = c
    

	WALL.erase(Vector2i(Rsmall[0], Csmall[0]))
	WALL.erase(Vector2i(Rsmall[er], Csmall[ec]))
    
	# Dijkstra's algorithm using MinHeap
	var Q: MinHeap = MinHeap.new()
	Q.push(0, Vector2i(Rsmall[0], Csmall[0]))
    
	var SEEN: Dictionary = {}
    
	while not Q.empty():
		var node: Dictionary = Q.pop()
		var dist: int = node["p"]
		var pos: Vector2i = node["v"]
		var curr_r: int = pos.x
		var curr_c: int = pos.y
        
		if Vector2i(curr_r, curr_c) == Vector2i(Rsmall[er], Csmall[ec]):
			return str(dist)
        
		if WALL.has(Vector2i(curr_r, curr_c)):
			continue
        
		if SEEN.has(Vector2i(curr_r, curr_c)):
			continue
        
		SEEN[Vector2i(curr_r, curr_c)] = true
        
		for dir: Vector2i in DIRS:
			var new_r: int = curr_r + dir.x
			var new_c: int = curr_c + dir.y
			if new_r < 0 or new_r >= Rs.size() or new_c < 0 or new_c >= Cs.size():
				continue
			var new_dist: int = dist + abs(Rbig[new_r] - Rbig[curr_r]) + abs(Cbig[new_c] - Cbig[curr_c])
			Q.push(new_dist, Vector2i(new_r, new_c))
    
	return "-1"  # No path found
    

func part2(data: String) -> String:
	return part1(data)


func part3(data: String) -> String:
	return part1(data)
