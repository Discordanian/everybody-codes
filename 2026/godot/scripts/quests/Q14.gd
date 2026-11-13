class_name Q14 extends RefCounted

func part1(data: String) -> String:
	return str(_bindings(data))


func part2(data: String) -> String:
	return str(data.length())


func part3(data: String) -> String:
	return str(data.length())


# One binding on every pixel edge between two different pieces, and on every
# pixel edge that touches the outside of the window. An edge shared by two
# pieces is counted once.
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
