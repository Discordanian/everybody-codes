class_name Q01 extends RefCounted



func next_full_square(num: int) -> int:
	var root: int = 0
	while root * root < num:
		root += 1
	return root * root - num

func part1(data: String) -> String:
	var cone_quantities: Array[Array] = ECodes.string_to_2d_int_array(data)
	var total: int = 0
	for cones: Array in cone_quantities:
		for num: int in cones:
			total += next_full_square(num)
	return str(total)


func part2(data: String) -> String:
	return str(data.length())


func part3(data: String) -> String:
	return str(data.length())
