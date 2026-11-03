class_name Q06 extends RefCounted

func part1(data: String) -> String:
	var recipes: Dictionary[String, Array] = _recipes(data)
	var seen: Set = Set.new()
	var queue: Array[String] = ["NULL"]
	seen.add("NULL")
	var head: int = 0
	while head < queue.size():
		var item: String = queue[head]
		head += 1
		if not recipes.has(item):
			continue
		for ingredient: String in recipes[item]:
			if seen.contains(ingredient):
				continue
			seen.add(ingredient)
			queue.append(ingredient)
	return str(seen.size() - 1)


func part2(data: String) -> String:
	return str(data.length())


func part3(data: String) -> String:
	return str(data.length())


func _recipes(data: String) -> Dictionary[String, Array]:
	var recipes: Dictionary[String, Array] = {}
	for line: String in ECodes.string_to_lines(data.replace("\r", "").strip_edges()):
		if line.is_empty():
			continue
		var parts: PackedStringArray = line.split(":", false)
		var ingredients: Array[String] = []
		for token: String in parts[1].split(",", false):
			ingredients.append(token.strip_edges())
		recipes[parts[0].strip_edges()] = ingredients
	return recipes
