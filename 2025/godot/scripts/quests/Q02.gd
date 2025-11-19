class_name Q02 extends RefCounted


static func _complex_add(lhs: Array[int], rhs: Array[int]) -> Array[int]:
	var retval: Array[int] = []
	retval.append(lhs[0] + rhs[0])
	retval.append(lhs[1] + rhs[1])
	return retval
	
   
static func _complex_multiply(lhs: Array[int], rhs: Array[int]) -> Array[int]:
	var retval: Array[int] = []
	retval.append(rhs[0] * lhs[0] - rhs[1] * lhs[1])
	retval.append(rhs[0] * lhs[1] + rhs[1] * lhs[0])
	return retval


static func _complex_division(rhs: Array[int], lhs: Array[int]) -> Array[int]:
	var retval: Array[int] = []
	@warning_ignore_start("integer_division")
	retval.append(rhs[0]/lhs[0])
	retval.append(rhs[1]/lhs[1])
	@warning_ignore_restore("integer_division")
	return retval


static func _cycle(r: Array[int], a: Array[int]) -> Array[int]:
	var retval: Array[int] = _complex_multiply(r, r)
	retval = _complex_division(retval, [10,10])
	retval = _complex_add(retval, a)
	return retval
 
static func _cycle64(r: Array[int], a: Array[int]) -> Array[int]:
	var retval: Array[int] = _complex_multiply(r, r)
	retval = _complex_division(retval, [100_000,100_000])
	retval = _complex_add(retval, a)
	return retval     

static func _good_cycle(a: Array[int]) -> int:
	var r: Array[int] = [0,0]
	for _i: int in range(100):
		r = _cycle64(r, a)
		if abs(r[0]) > 1_000_000 or abs(r[1]) > 1_000_000:
			return 0
	return 1


static func part1(data: String) -> String:
	var a: Array[int] = ECodes.array_int_from_string(data)
	var r: Array[int] = [0, 0]
	r = _cycle(r,a)
	r = _cycle(r,a)
	r = _cycle(r,a)
	return "[%d,%d]" % [r[0], r[1]]
	

static func part2(data: String) -> String:
	var a: Array[int] = ECodes.array_int_from_string(data)
	var good: int = 0
	for y: int in range(101):
		for x: int in range(101):
			good += _good_cycle(_complex_add(a, [x*10, y*10]))
	return str(good)


static func part3(data: String) -> String:
	var a: Array[int] = ECodes.array_int_from_string(data)
	var good: int = 0
	for y: int in range(1001):
		for x: int in range(1001):
			good += _good_cycle(_complex_add(a, [x, y]))
	return str(good)
