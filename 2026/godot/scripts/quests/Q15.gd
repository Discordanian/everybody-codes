class_name Q15 extends RefCounted

func part1(data: String) -> String:
	return str(_route(data))


func part2(data: String) -> String:
	return str(_haul(data))


func part3(data: String) -> String:
	return str(_exact(data))


func _route(data: String) -> int:
	var grid: Array[Array] = ECodes.string_to_2d_char_array(data.strip_edges())
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	var rows: int = size.x
	var cols: int = size.y
	var facing: Array[Vector2i] = [ECodes.EAST, ECodes.SOUTH, ECodes.WEST, ECodes.NORTH]
	var ids: Dictionary = {}
	var deposit_of: PackedInt32Array = PackedInt32Array()
	var start: int = -1
	var goal: int = -1
	var deposits: int = 0
	for y: int in rows:
		for x: int in cols:
			var cell: String = grid[y][x]
			if cell == "#":
				continue
			ids[Vector2i(x, y)] = deposit_of.size()
			var bit: int = -1
			if cell == "S":
				start = deposit_of.size()
			elif cell == "E":
				goal = deposit_of.size()
			elif cell == "@":
				bit = deposits
				deposits += 1
			deposit_of.append(bit)
	var count: int = deposit_of.size()
	var ahead: PackedInt32Array = PackedInt32Array()
	ahead.resize(count * 4)
	ahead.fill(-1)
	for place: Vector2i in ids:
		var here: int = ids[place]
		for dir: int in 4:
			var step: Vector2i = place + facing[dir]
			if ids.has(step):
				ahead[here * 4 + dir] = ids[step]
	var full: int = (1 << deposits) - 1
	var seen: Dictionary = {}
	var q_cell: PackedInt32Array = PackedInt32Array()
	var q_dir: PackedInt32Array = PackedInt32Array()
	var q_mask: PackedInt32Array = PackedInt32Array()
	var q_dist: PackedInt32Array = PackedInt32Array()
	for dir: int in 4:
		var first: int = ahead[start * 4 + dir]
		if first < 0:
			continue
		var mask: int = 0
		if deposit_of[first] >= 0:
			mask = 1 << deposit_of[first]
		_push(seen, q_cell, q_dir, q_mask, q_dist, first, dir, mask, 1, deposits)
	var head: int = 0
	while head < q_cell.size():
		var cell: int = q_cell[head]
		var dir: int = q_dir[head]
		var mask: int = q_mask[head]
		var dist: int = q_dist[head]
		head += 1
		if cell == goal and mask == full:
			return dist
		for turn: int in [0, 1, 3]:
			var next_dir: int = (dir + turn) % 4
			var nxt: int = ahead[cell * 4 + next_dir]
			if nxt < 0:
				continue
			var next_mask: int = mask
			if deposit_of[nxt] >= 0:
				next_mask |= 1 << deposit_of[nxt]
			_push(seen, q_cell, q_dir, q_mask, q_dist, nxt, next_dir, next_mask, dist + 1, deposits)
	return -1


func _push(
	seen: Dictionary,
	q_cell: PackedInt32Array,
	q_dir: PackedInt32Array,
	q_mask: PackedInt32Array,
	q_dist: PackedInt32Array,
	cell: int,
	dir: int,
	mask: int,
	dist: int,
	deposits: int,
) -> void:
	var state: int = ((cell * 4 + dir) << deposits) | mask
	if seen.has(state):
		return
	seen[state] = true
	q_cell.append(cell)
	q_dir.append(dir)
	q_mask.append(mask)
	q_dist.append(dist)


const QUOTA: int = 2026
const EXACT: int = 202620262026


func _haul(data: String) -> int:
	var grid: Array[Array] = ECodes.string_to_2d_char_array(data.strip_edges())
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	var rows: int = size.x
	var cols: int = size.y
	var facing: Array[Vector2i] = [ECodes.EAST, ECodes.SOUTH, ECodes.WEST, ECodes.NORTH]
	var ids: Dictionary = {}
	var deposit: PackedByteArray = PackedByteArray()
	var start: int = -1
	var goal: int = -1
	for y: int in rows:
		for x: int in cols:
			var cell: String = grid[y][x]
			if cell == "#":
				continue
			ids[Vector2i(x, y)] = deposit.size()
			if cell == "S":
				start = deposit.size()
			elif cell == "E":
				goal = deposit.size()
			deposit.append(1 if cell == "@" else 0)
	var count: int = deposit.size()
	var ahead: PackedInt32Array = PackedInt32Array()
	ahead.resize(count * 4)
	ahead.fill(-1)
	for place: Vector2i in ids:
		var here: int = ids[place]
		for dir: int in 4:
			var step: Vector2i = place + facing[dir]
			if ids.has(step):
				ahead[here * 4 + dir] = ids[step]
	var span: int = QUOTA + 1
	var seen: PackedByteArray = PackedByteArray()
	seen.resize(count * 4 * span)
	var q_cell: PackedInt32Array = PackedInt32Array()
	var q_dir: PackedInt32Array = PackedInt32Array()
	var q_sulphur: PackedInt32Array = PackedInt32Array()
	var q_dist: PackedInt32Array = PackedInt32Array()
	for dir: int in 4:
		var first: int = ahead[start * 4 + dir]
		if first < 0:
			continue
		var carried: int = deposit[first]
		_push_haul(seen, q_cell, q_dir, q_sulphur, q_dist, first, dir, carried, 1, span)
	var head: int = 0
	while head < q_cell.size():
		var cell: int = q_cell[head]
		var dir: int = q_dir[head]
		var carried: int = q_sulphur[head]
		var dist: int = q_dist[head]
		head += 1
		if cell == goal and carried >= QUOTA:
			return dist
		for turn: int in [0, 1, 3]:
			var next_dir: int = (dir + turn) % 4
			var nxt: int = ahead[cell * 4 + next_dir]
			if nxt < 0:
				continue
			var gained: int = carried + deposit[nxt]
			if gained > QUOTA:
				gained = QUOTA
			_push_haul(seen, q_cell, q_dir, q_sulphur, q_dist, nxt, next_dir, gained, dist + 1, span)
	return -1


func _push_haul(
	seen: PackedByteArray,
	q_cell: PackedInt32Array,
	q_dir: PackedInt32Array,
	q_sulphur: PackedInt32Array,
	q_dist: PackedInt32Array,
	cell: int,
	dir: int,
	carried: int,
	dist: int,
	span: int,
) -> void:
	var slot: int = (cell * 4 + dir) * span + carried
	if seen[slot] != 0:
		return
	seen[slot] = 1
	q_cell.append(cell)
	q_dir.append(dir)
	q_sulphur.append(carried)
	q_dist.append(dist)



func _exact(data: String) -> int:
	var grid: Array[Array] = ECodes.string_to_2d_char_array(data.strip_edges())
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	var rows: int = size.x
	var cols: int = size.y
	var facing: Array[Vector2i] = [ECodes.EAST, ECodes.SOUTH, ECodes.WEST, ECodes.NORTH]
	var ids: Dictionary = {}
	var deposit: PackedByteArray = PackedByteArray()
	var start: int = -1
	var goal: int = -1
	for y: int in rows:
		for x: int in cols:
			var cell: String = grid[y][x]
			if cell == "#":
				continue
			ids[Vector2i(x, y)] = deposit.size()
			if cell == "S":
				start = deposit.size()
			elif cell == "E":
				goal = deposit.size()
			deposit.append(1 if cell == "@" else 0)
	var count: int = deposit.size()
	var open: PackedInt32Array = PackedInt32Array()
	open.resize(count * 4)
	open.fill(-1)
	for place: Vector2i in ids:
		var here: int = ids[place]
		for dir: int in 4:
			var step: Vector2i = place + facing[dir]
			if ids.has(step):
				open[here * 4 + dir] = ids[step]
	var states: int = count * 4
	var edge_to: PackedInt32Array = PackedInt32Array()
	var edge_gain: PackedByteArray = PackedByteArray()
	edge_to.resize(states * 3)
	edge_gain.resize(states * 3)
	edge_to.fill(-1)
	for cell: int in count:
		for dir: int in 4:
			var state: int = cell * 4 + dir
			var slot: int = 0
			for turn: int in [0, 1, 3]:
				var next_dir: int = (dir + turn) % 4
				var nxt: int = open[cell * 4 + next_dir]
				if nxt >= 0:
					edge_to[state * 3 + slot] = nxt * 4 + next_dir
					edge_gain[state * 3 + slot] = deposit[nxt]
				slot += 1
	var useful: PackedByteArray = _useful(states, edge_to, open, start, goal)
	var rate: Vector2i = _best_rate(states, edge_to, edge_gain, useful)
	var gain: int = rate.x
	var loop_time: int = rate.y
	var limit: int = 256
	while limit <= states:
		var times: PackedInt32Array = _exact_times(states, edge_to, edge_gain, open, start, goal, deposit, limit)
		var answer: int = _project(times, gain, loop_time, limit)
		if answer >= 0:
			return answer
		limit *= 2
	return -1


func _useful(
	states: int,
	edge_to: PackedInt32Array,
	open: PackedInt32Array,
	start: int,
	goal: int,
) -> PackedByteArray:
	var reach: PackedByteArray = PackedByteArray()
	reach.resize(states)
	var q: PackedInt32Array = PackedInt32Array()
	var head: int = 0
	for dir: int in 4:
		var first: int = open[start * 4 + dir]
		if first < 0:
			continue
		var state: int = first * 4 + dir
		if reach[state] == 0:
			reach[state] = 1
			q.append(state)
	while head < q.size():
		var state: int = q[head]
		head += 1
		for slot: int in 3:
			var nxt: int = edge_to[state * 3 + slot]
			if nxt >= 0 and reach[nxt] == 0:
				reach[nxt] = 1
				q.append(nxt)
	var rev_count: PackedInt32Array = PackedInt32Array()
	rev_count.resize(states)
	for state: int in states:
		if reach[state] == 0:
			continue
		for slot: int in 3:
			var nxt: int = edge_to[state * 3 + slot]
			if nxt >= 0 and reach[nxt] != 0:
				rev_count[nxt] += 1
	var rev_at: PackedInt32Array = PackedInt32Array()
	rev_at.resize(states)
	var total: int = 0
	for state: int in states:
		rev_at[state] = total
		total += rev_count[state]
	var rev_to: PackedInt32Array = PackedInt32Array()
	rev_to.resize(total)
	var filled: PackedInt32Array = PackedInt32Array()
	filled.resize(states)
	for state: int in states:
		if reach[state] == 0:
			continue
		for slot: int in 3:
			var nxt: int = edge_to[state * 3 + slot]
			if nxt >= 0 and reach[nxt] != 0:
				rev_to[rev_at[nxt] + filled[nxt]] = state
				filled[nxt] += 1
	var to_goal: PackedByteArray = PackedByteArray()
	to_goal.resize(states)
	q = PackedInt32Array()
	head = 0
	for dir: int in 4:
		var state: int = goal * 4 + dir
		if reach[state] != 0:
			to_goal[state] = 1
			q.append(state)
	while head < q.size():
		var state: int = q[head]
		head += 1
		for index: int in rev_count[state]:
			var prev: int = rev_to[rev_at[state] + index]
			if to_goal[prev] == 0:
				to_goal[prev] = 1
				q.append(prev)
	var useful: PackedByteArray = PackedByteArray()
	useful.resize(states)
	for state: int in states:
		if reach[state] != 0 and to_goal[state] != 0:
			useful[state] = 1
	return useful


func _best_rate(
	states: int,
	edge_to: PackedInt32Array,
	edge_gain: PackedByteArray,
	useful: PackedByteArray,
) -> Vector2i:
	var order: PackedInt32Array = _finish(states, edge_to, useful)
	var rev_count: PackedInt32Array = PackedInt32Array()
	rev_count.resize(states)
	for state: int in states:
		if useful[state] == 0:
			continue
		for slot: int in 3:
			var nxt: int = edge_to[state * 3 + slot]
			if nxt >= 0 and useful[nxt] != 0:
				rev_count[nxt] += 1
	var rev_at: PackedInt32Array = PackedInt32Array()
	rev_at.resize(states)
	var total: int = 0
	for state: int in states:
		rev_at[state] = total
		total += rev_count[state]
	var rev_to: PackedInt32Array = PackedInt32Array()
	rev_to.resize(total)
	var filled: PackedInt32Array = PackedInt32Array()
	filled.resize(states)
	for state: int in states:
		if useful[state] == 0:
			continue
		for slot: int in 3:
			var nxt: int = edge_to[state * 3 + slot]
			if nxt >= 0 and useful[nxt] != 0:
				rev_to[rev_at[nxt] + filled[nxt]] = state
				filled[nxt] += 1
	var seen: PackedByteArray = PackedByteArray()
	seen.resize(states)
	var best_gain: int = 0
	var best_time: int = 1
	var comp: PackedInt32Array = PackedInt32Array()
	for index: int in range(order.size() - 1, -1, -1):
		var seed: int = order[index]
		if seen[seed] != 0:
			continue
		comp.resize(0)
		var stack: PackedInt32Array = PackedInt32Array()
		stack.append(seed)
		seen[seed] = 1
		var head: int = 0
		while head < stack.size():
			var state: int = stack[head]
			head += 1
			comp.append(state)
			for offset: int in rev_count[state]:
				var prev: int = rev_to[rev_at[state] + offset]
				if seen[prev] == 0 and useful[prev] != 0:
					seen[prev] = 1
					stack.append(prev)
		if comp.size() < 2:
			continue
		var rate: Vector2i = _karp(comp, edge_to, edge_gain)
		if rate.x * best_time > best_gain * rate.y:
			best_gain = rate.x
			best_time = rate.y
	var divisor: int = AoCMath.gcd(best_gain, best_time)
	@warning_ignore("integer_division")
	return Vector2i(best_gain / divisor, best_time / divisor)


func _finish(states: int, edge_to: PackedInt32Array, useful: PackedByteArray) -> PackedInt32Array:
	var color: PackedByteArray = PackedByteArray()
	color.resize(states)
	var order: PackedInt32Array = PackedInt32Array()
	for seed: int in states:
		if useful[seed] == 0 or color[seed] != 0:
			continue
		var stack: PackedInt32Array = PackedInt32Array()
		var cursor: PackedInt32Array = PackedInt32Array()
		stack.append(seed)
		cursor.append(0)
		color[seed] = 1
		while stack.size() > 0:
			var at: int = stack.size() - 1
			var state: int = stack[at]
			var edge: int = cursor[at]
			var descended: bool = false
			while edge < 3:
				var nxt: int = edge_to[state * 3 + edge]
				edge += 1
				if nxt >= 0 and useful[nxt] != 0 and color[nxt] == 0:
					cursor[at] = edge
					stack.append(nxt)
					cursor.append(0)
					color[nxt] = 1
					descended = true
					break
			if descended:
				continue
			stack.resize(at)
			cursor.resize(at)
			color[state] = 2
			order.append(state)
	return order


func _karp(
	comp: PackedInt32Array,
	edge_to: PackedInt32Array,
	edge_gain: PackedByteArray,
) -> Vector2i:
	var n: int = comp.size()
	var local: Dictionary = {}
	for index: int in n:
		local[comp[index]] = index
	var from: PackedInt32Array = PackedInt32Array()
	var to: PackedInt32Array = PackedInt32Array()
	var gain: PackedInt32Array = PackedInt32Array()
	for index: int in n:
		var state: int = comp[index]
		for slot: int in 3:
			var nxt: int = edge_to[state * 3 + slot]
			if nxt >= 0 and local.has(nxt):
				from.append(index)
				to.append(local[nxt])
				gain.append(edge_gain[state * 3 + slot])
	var dp: PackedInt32Array = PackedInt32Array()
	dp.resize((n + 1) * n)
	dp.fill(-1)
	for node: int in n:
		dp[node] = 0
	var edges: int = from.size()
	for length: int in range(1, n + 1):
		for edge: int in edges:
			var prev: int = dp[(length - 1) * n + from[edge]]
			if prev < 0:
				continue
			var value: int = prev + gain[edge]
			var slot: int = length * n + to[edge]
			if dp[slot] < value:
				dp[slot] = value
	var best_gain: int = 0
	var best_time: int = 1
	for node: int in n:
		if dp[n * n + node] < 0:
			continue
		var cur_gain: int = -1
		var cur_time: int = 1
		for length: int in n:
			if dp[length * n + node] < 0:
				continue
			var num: int = dp[n * n + node] - dp[length * n + node]
			var den: int = n - length
			if cur_gain < 0 or num * cur_time < cur_gain * den:
				cur_gain = num
				cur_time = den
		if cur_gain > 0 and cur_gain * best_time > best_gain * cur_time:
			best_gain = cur_gain
			best_time = cur_time
	var divisor: int = AoCMath.gcd(best_gain, best_time)
	@warning_ignore("integer_division")
	return Vector2i(best_gain / divisor, best_time / divisor)


func _exact_times(
	states: int,
	edge_to: PackedInt32Array,
	edge_gain: PackedByteArray,
	open: PackedInt32Array,
	start: int,
	goal: int,
	deposit: PackedByteArray,
	limit: int,
) -> PackedInt32Array:
	var span: int = limit + 1
	var best: PackedInt32Array = PackedInt32Array()
	best.resize(states * span)
	best.fill(1000000000)
	var q: PackedInt32Array = PackedInt32Array()
	var head: int = 0
	for dir: int in 4:
		var first: int = open[start * 4 + dir]
		if first < 0:
			continue
		var carried: int = deposit[first]
		if carried > limit:
			continue
		var state: int = first * 4 + dir
		var key: int = state * span + carried
		if best[key] > 1:
			best[key] = 1
			q.append(key)
	while head < q.size():
		var key: int = q[head]
		head += 1
		@warning_ignore("integer_division")
		var state: int = key / span
		var carried: int = key % span
		var dist: int = best[key]
		for slot: int in 3:
			var nxt: int = edge_to[state * 3 + slot]
			if nxt < 0:
				continue
			var gained: int = carried + edge_gain[state * 3 + slot]
			if gained > limit:
				continue
			var nkey: int = nxt * span + gained
			if dist + 1 < best[nkey]:
				best[nkey] = dist + 1
				q.append(nkey)
	var times: PackedInt32Array = PackedInt32Array()
	times.resize(span)
	for sulphur: int in span:
		var fastest: int = 1000000000
		for dir: int in 4:
			fastest = mini(fastest, best[(goal * 4 + dir) * span + sulphur])
		times[sulphur] = fastest
	return times


func _project(times: PackedInt32Array, gain: int, loop_time: int, limit: int) -> int:
	for copies: int in range(1, 9):
		var step: int = copies * gain
		var extra: int = copies * loop_time
		if step <= 0 or limit < step * 4:
			continue
		var last_bad: int = -1
		for sulphur: int in range(limit - step + 1):
			if times[sulphur] >= 1000000000 or times[sulphur + step] >= 1000000000 or times[sulphur + step] != times[sulphur] + extra:
				last_bad = sulphur
		var origin: int = last_bad + 1
		if limit - origin < step * 4:
			continue
		var offset: int = (EXACT - origin) % step
		var base: int = origin + offset
		@warning_ignore("integer_division")
		var loops: int = (EXACT - base) / step
		return times[base] + loops * extra
	return -1
