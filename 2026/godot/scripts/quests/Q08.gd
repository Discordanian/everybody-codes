class_name Q08 extends RefCounted

func part1(data: String) -> String:
	var grid: Array[Array] = ECodes.string_to_2d_char_array(data.replace("\r", "").strip_edges())
	var size: Vector2i = ECodes.dimensions_of_2d_array(grid)
	var rows: int = size.x
	var cols: int = size.y
	var shadow: PackedInt32Array = PackedInt32Array()
	shadow.resize(rows * cols)
	var lit: int = 0
	for r: int in rows:
		var row: Array = grid[r]
		for c: int in cols:
			var ch: String = row[c]
			if not ch.is_valid_int():
				continue
			var height: int = ch.to_int()
			var shade: int = 0
			if r > 0 and c > 0:
				var prev: String = grid[r - 1][c - 1]
				if prev.is_valid_int():
					shade = maxi(shadow[(r - 1) * cols + (c - 1)] - 1, prev.to_int() - 1)
			shadow[r * cols + c] = shade
			if height > shade:
				lit += 1
	return str(lit)


func part2(data: String) -> String:
	return str(data.length())


func part3(data: String) -> String:
	return str(data.length())
