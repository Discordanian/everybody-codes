extends Control

@export var day: int = 9
@export var year: int = 2025

#region Boilerplate
@onready var answer1: LineEdit = $MarginContainer/VBoxContainer/Assignment/VBoxContainer/Answer1
@onready var answer2: LineEdit = $MarginContainer/VBoxContainer/Assignment/VBoxContainer/Answer2
@onready var answer3: LineEdit = $MarginContainer/VBoxContainer/Assignment/VBoxContainer/Answer3

@onready var example1: LineEdit = $MarginContainer/VBoxContainer/Assignment/VBoxContainer/ExAnswer1
@onready var example2: LineEdit = $MarginContainer/VBoxContainer/Assignment/VBoxContainer/ExAnswer2
@onready var example3: LineEdit = $MarginContainer/VBoxContainer/Assignment/VBoxContainer/ExAnswer3

@onready var exampleText: TextEdit = $MarginContainer/VBoxContainer/Assignment/Example/ExampleTextEdit
@onready var exampleText2: TextEdit = $MarginContainer/VBoxContainer/Assignment/Example/ExampleTextEdit2
@onready var exampleText3: TextEdit = $MarginContainer/VBoxContainer/Assignment/Example/ExampleTextEdit3

@onready var exampleButton: Button = %ExampleRunButton
@onready var inputButton: Button = %InputRunButton


var example_path1: String
var example_path2: String
var example_path3: String

var debug: bool

func debug_print(...args: Array) -> void:
	if debug:
		print(args)

		 
func setup_example() -> void:
	var content1: String =  ECodes.string_from_file(example_path1)
	var content2: String =  ECodes.string_from_file(example_path2)
	var content3: String =  ECodes.string_from_file(example_path3)
	exampleText.text = content1
	exampleText2.text = content2
	exampleText3.text = content3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/VBoxContainer/Header/Label.text = "Everybody Codes Day %02d" % [day]
	example_path1 = ECodes.example_path(year,day, 1)
	example_path2 = ECodes.example_path(year,day, 2)
	example_path3 = ECodes.example_path(year, day, 3)
	setup_example()


func _on_example_text_edit_text_changed() -> void:
	var file: FileAccess = FileAccess.open(example_path1, FileAccess.WRITE)
	if file:
		file.store_string(exampleText.text)
		file.close()
	else:
		push_error("Error writing to " + example_path1)
	
func _on_example_text_edit_text_changed2() -> void:
	var file: FileAccess = FileAccess.open(example_path2, FileAccess.WRITE)
	if file:
		file.store_string(exampleText2.text)
		file.close()
	else:
		push_error("Error writing to " + example_path2)

func _on_example_pressed() -> void:
	print_debug("_on_example_pressed()")
	var data1: String = ECodes.string_from_file(example_path1)
	var data2: String = ECodes.string_from_file(example_path2)
	var data3: String = ECodes.string_from_file(example_path3)
	debug = true
	
	part1(data1, example1)
	part2(data2, example2)
	part3(data3, example3)
	
func _on_input_pressed() -> void:
	var path1: String = ECodes.input_path(year, day, 1)
	var path2: String = ECodes.input_path(year, day, 2)
	var path3: String = ECodes.input_path(year, day, 3)
	debug = false
	
	answer1.text = "Input file not found"
	answer2.text = "Input file not found"
	answer3.text = "Input file not found"
	
	if FileAccess.file_exists(path1):
		part1(ECodes.string_from_file(path1), answer1)

	if FileAccess.file_exists(path2):
		part2(ECodes.string_from_file(path2), answer2)        
	
	if FileAccess.file_exists(path3):
		part3(ECodes.string_from_file(path3), answer3)


func _on_main_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_entry.tscn") 


func _on_example_text_edit_3_text_changed() -> void:
	var file: FileAccess = FileAccess.open(example_path3, FileAccess.WRITE)
	if file:
		file.store_string(exampleText3.text)
		file.close()
	else:
		push_error("Error writing to " + example_path3)

#endregion

func dna_child(lines: PackedStringArray) -> int:
	var child: Array[int] = [0,1,2]
	var l: int = lines[0].length()
	for idx: int in range(l):
		if child.size() == 1:
			return child[0]
		if lines[0][idx] == lines[1][idx] and lines[0][idx] != lines[2][idx]:
			child.erase(2)
		if lines[0][idx] == lines[2][idx] and lines[0][idx] != lines[1][idx]:
			child.erase(1)
		if lines[2][idx] == lines[1][idx] and lines[0][idx] != lines[2][idx]:
			child.erase(0)
	return child[0]

func are_parents(p1: int, p2: int, child: int, dna: PackedStringArray) -> bool:
	for idx: int in range(dna[0].length()):
		if dna[child][idx] != dna[p1][idx] and dna[child][idx] != dna[p2][idx]:
			return false
	debug_print("Parents ", p1, " " , p2, " -> ", child)
	return true
				 

func distance(parent: int, child: int, lines:PackedStringArray) -> int:
	var retval: int = 0
	for idx: int in range(lines[0].length()):
		if lines[parent][idx] == lines[child][idx]:
			retval += 1
	
	return retval

func part1(data: String, ans: LineEdit) -> void:
	var lines: PackedStringArray = ECodes.string_to_lines(data.strip_edges())
	for idx: int in range(lines.size()):
		lines[idx] = lines[idx].split(":")[1]    
	
	var child_idx: int = dna_child(lines)
	var line_numbers: Array[int] = [0,1,2]
	line_numbers.erase(child_idx)
	var retval: int = distance(line_numbers[0], child_idx, lines) * distance(line_numbers[1], child_idx, lines)
	
	ans.text = str(retval)
	
	
func part2(data: String, ans: LineEdit) -> void:
	var lines: PackedStringArray = ECodes.string_to_lines(data.strip_edges())
	for idx: int in range(lines.size()):
		lines[idx] = lines[idx].split(":")[1]
		
	
	
	
	var tree: Dictionary = {}
	var retval: int = 0
	for p1: int in range(lines.size() - 1):
		for p2: int in range(p1 + 1, lines.size()):
			for c: int in range(lines.size()):
				if c == p1 or c == p2:
					continue
				if are_parents(p1, p2, c, lines):
					var key: Vector2i = Vector2i(p1, p2)
					if not tree.has(key):
						tree[key] = []
					tree[key].append(c)
	debug_print(tree)
	for key: Vector2i in tree.keys():
		for c: int in tree[key]:
			retval += distance(key.x, c, lines) * distance(key.y, c, lines)
			
		
	
	ans.text = str(retval)


func part3(data: String, ans: LineEdit) -> void:
	var lines: PackedStringArray = ECodes.string_to_lines(data.strip_edges())
	for idx: int in range(lines.size()):
		lines[idx] = lines[idx].split(":")[1]    
	var families: Array[Set] = []
	for p1: int in range(lines.size() - 1):
		for p2: int in range(p1 +1, lines.size()):
			for c: int in range(lines.size()):
				if c == p1 or c == p2:
					continue
				if are_parents(p1, p2, c, lines):
					var inserted: bool = false
					for s: Set in families:
						if s.contains(p1) or s.contains(p2) or s.contains(c):
							s.add(p2)
							s.add(c)
							s.add(p1)
							inserted = true
					if not inserted:
						var new_fam: Set = Set.new()
						new_fam.add_all([p1, p2, c])
						families.append(new_fam)
	debug_print(families)
	var merged_families: Array[Set] = consolidate_sets(families)
	var max_idx: int = 0
	var max_size: int = 0
	for idx: int in range(merged_families.size()):
		if merged_families[idx].size() > max_size:
			max_size = merged_families[idx].size()
			max_idx = idx
	
	debug_print(max_idx, merged_families)        
	var retval: int = 0
	for i: int in merged_families[max_idx]:
		retval += (i+1)                    
	
	ans.text = str(retval)

func consolidate_sets(sets: Array[Set]) -> Array[Set]:
	"""
	Merges any sets that share at least one common element.
	Returns an array of disjoint sets.
	"""
	if sets.is_empty():
		return []
	
	# Map each element to the index of the first set it appears in
	var element_to_set_idx: Dictionary = {}
	
	# Initialize union-find structure with one entry per set
	var uf: UnionFind = UnionFind.new(sets.size())
	
	# Process each set and its elements
	for set_idx: int in range(sets.size()):
		var current_set: Set = sets[set_idx]
		for element: Variant in current_set:
			if element in element_to_set_idx:
				# This element exists in another set - unite them
				var other_set_idx: int = element_to_set_idx[element]
				uf.unite(set_idx, other_set_idx)
			else:
				# First time seeing this element
				element_to_set_idx[element] = set_idx
	
	# Group set indices by their root representative
	var groups: Dictionary = {}
	for i: int in range(sets.size()):
		var root: int = uf.find(i)
		if root not in groups:
			groups[root] = []
		groups[root].append(i)
	
	# Merge sets in each group
	var result: Array[Set] = []
	for group_indices: Variant in groups.values():
		var merged_set: Set = Set.new()
		for idx: Variant in group_indices:
			for element: Variant in sets[idx]:
				merged_set.add(element)
		result.append(merged_set)
	
	return result
