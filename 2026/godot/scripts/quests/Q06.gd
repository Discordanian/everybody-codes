class_name Q06 extends RefCounted

func part1(data: String) -> String:
	return str(_count(_recipes(data)))


func part2(data: String) -> String:
	return str(_count(_users(_recipes(data))))


func part3(data: String) -> String:
	return str(data.length())


# BFS from NULL. 
func _count(links: Dictionary[String, Array]) -> int:
	var seen: Set = Set.new()
	var queue: Array[String] = ["NULL"]
	seen.add("NULL")
	var head: int = 0
	while head < queue.size():
		var item: String = queue[head]
		head += 1
		if not links.has(item):
			continue
		for next: String in links[item]:
			if seen.contains(next):
				continue
			seen.add(next)
			queue.append(next)
	return seen.size() - 1


# Reverse each recipe 
func _users(recipes: Dictionary[String, Array]) -> Dictionary[String, Array]:
	var users: Dictionary[String, Array] = {}
	for item: String in recipes:
		for ingredient: String in recipes[item]:
			if not users.has(ingredient):
				users[ingredient] = []
			users[ingredient].append(item)
	return users


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
