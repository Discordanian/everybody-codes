class_name Q06 extends RefCounted

func part1(data: String) -> String:
	return str(_count(_recipes(data)))


func part2(data: String) -> String:
	return str(_count(_users(_recipes(data))))


func part3(data: String) -> String:
	var recipes: Dictionary[String, Array] = _recipes(data)
	var users: Dictionary[String, Array] = _users(recipes)
	var hits: Counter = Counter.new()
	for version: String in _null_versions(recipes):
		for product: String in _reachable(users, version):
			hits.add(product)
	var contaminated: int = 0
	for product: Variant in hits.items():
		if hits.get_count(product) >= 2:
			contaminated += 1
	return str(contaminated)


# BFS from NULL. The start is not included.
func _count(links: Dictionary[String, Array]) -> int:
	return _reachable(links, "NULL").size()


# BFS. The start is not included.
func _reachable(links: Dictionary[String, Array], start: String) -> Array[String]:
	var seen: Set = Set.new()
	var queue: Array[String] = [start]
	var found: Array[String] = []
	seen.add(start)
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
			found.append(next)
			queue.append(next)
	return found


func _null_versions(recipes: Dictionary[String, Array]) -> Array[String]:
	var found: Set = Set.new()
	for item: String in recipes:
		if item.begins_with("NULL"):
			found.add(item)
		for ingredient: String in recipes[item]:
			if ingredient.begins_with("NULL"):
				found.add(ingredient)
	var versions: Array[String] = []
	for version: String in found:
		versions.append(version)
	return versions


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
