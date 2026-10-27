class_name Q01 extends RefCounted



func next_full_square(num: int) -> int:
	var root: int = 0
	while root * root < num:
		root += 1
	return root * root - num


func next_hollow_square(num: int) -> int:
	# Border only. Side n uses 4 * (n - 1) cones: 3x3 = 8, 4x4 = 12, 5x5 = 16.
	var cones: int = 8
	while cones < num:
		cones += 4
	return cones - num

func next_one_hole_square(num: int) -> int:
	var root: int = 3
	while (root * root) - 1 < num:
		root += 2
	return (root * root) - 1 - num

func part1(data: String) -> String:
	var cone_quantities: Array[Array] = ECodes.string_to_2d_int_array(data)
	var total: int = 0
	for cones: Array in cone_quantities:
		for num: int in cones:
			total += next_full_square(num)
	return str(total)


func part2(data: String) -> String:
	var cone_quantities: Array[Array] = ECodes.string_to_2d_int_array(data)
	var total: int = 0
	for cones: Array in cone_quantities:
		for num: int in cones:
			total += next_hollow_square(num)
	return str(total)


func part3(data: String) -> String:
	var cone_quantities: Array[Array] = ECodes.string_to_2d_int_array(data)
	var total: int = 0
	for cones: Array in cone_quantities:
		for num: int in cones:
			total += next_one_hole_square(num)
	return str(total)
