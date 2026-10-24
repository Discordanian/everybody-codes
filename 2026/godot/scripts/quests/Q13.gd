class_name Q13 extends RefCounted


static func part1(data: String) -> String:
	var nums: Array[int] = ECodes.array_int_from_string(data)
	var wheel: Array[int] = [1]
	var back: bool = true
	for num: int in nums:

		if back:
			wheel.push_back(num)
		else:
			wheel.push_front(num)
		back = !back
	var idx: int = wheel.find(1)
	idx += 2025
	idx = idx % wheel.size()
	return str(wheel[idx])
    

static func part2(data: String) -> String:
	var lines: PackedStringArray = ECodes.string_to_lines(data.strip_edges())
	var wheel: Array[Vector2i] = [Vector2i(1,1)]
	var back: bool = true
	var digits: int = 1
	var answer: int = 0
	for l: String in lines:
		var temp: PackedStringArray = l.split("-")
		var nums: Array[int] = [int(temp[0]),int(temp[1])]
		var r: Vector2i = Vector2i(nums[0], nums[1])
		var range_length: int = ((nums[1] - nums[0]) + 1)
		digits += range_length
		if back:
			wheel.push_back(r)
		else:
			wheel.push_front(r)
		back = !back
	var reorder: bool = true
	while reorder:
		if wheel[0] == Vector2i(1,1):
			reorder = false
			continue
		var r: Vector2i = wheel.pop_front()
		wheel.push_back(r)
	var idx:int  = 20252025 % digits
	print(idx)
	print(digits)
	var cur_idx: int = 0
	for r: Vector2i in wheel:
		var l: int = 1 + (r.y - r.x)
		if idx < (cur_idx + l):
			# It's in this range
			print("in this range", r," ", idx," ", cur_idx)
			return str(r.x + (idx - cur_idx))

		else:
			cur_idx += l  
        
	return str(answer)


static func part3(data: String) -> String:
	return data
