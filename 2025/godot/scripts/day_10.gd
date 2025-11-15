extends Control

@export var day: int = 10
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


const MOVES: Array[Vector2i] = [
    Vector2i(2,1),
    Vector2i(-2,1),
    Vector2i(2,-1),
    Vector2i(-2,-1),
    Vector2i(1,2),
    Vector2i(-1,2),
    Vector2i(1,-2),
    Vector2i(-1,-2),
]

func move(visited: Set) -> Set:
    var retval: Set = Set.new()
    
    for pos: Vector2i in visited:
        retval.add(pos)
        for delta: Vector2i in MOVES:
            retval.add(pos + delta)
    return retval

#region Part2Support
func dragon_move(visited: Set, bounds: int) -> Set:
    var retval: Set = Set.new()
    
    for pos: Vector2i in visited:
        for delta: Vector2i in MOVES:
            var next: Vector2i = pos + delta
            if next.x >= 0 and next.x <= bounds and next.y >= 0 and next.y <= bounds:
                retval.add(next)
    return retval

func sheep_move(sheep: Set, bounds: int) -> Set:
    var retval: Set = Set.new()
    var down: Vector2i = Vector2i(0,1)
    
    for s: Vector2i in sheep:
        var next: Vector2i = s + down
        if next.y < bounds:
            retval.add(next)
    return retval

#endregion

#region Part3Support
func get_cache_key(x: int, y: int, sheep: Set, turn: int) -> String:
    var sheep_array: Array = sheep.get_as_array()
    sheep_array.sort_custom(func(a: Vector2i, b: Vector2i) -> bool: 
        if a.x != b.x:
            return a.x < b.x
        return a.y < b.y
    )
    return str(x) + "," + str(y) + "," + str(sheep_array) + "," + str(turn)

func calculate_paths_iterative(grid: Array[String], grid_size: int, start_x: int, start_y: int, start_sheep: Set) -> int:
    var memo: Dictionary = {}
    var stack: Array[Dictionary] = []
    var call_stack: Array[Dictionary] = []
    
    # Push initial state as dictionary
    stack.push_back({"x": start_x, "y": start_y, "sheep": start_sheep, "turn": 0, "depth": 0})
    
    while not stack.is_empty():
        var state: Dictionary = stack.pop_back()
        var cache_key: String = get_cache_key(state["x"], state["y"], state["sheep"], state["turn"])
        
        # Check if already computed
        if cache_key in memo:
            if not call_stack.is_empty():
                var parent: Dictionary = call_stack.pop_back()
                parent["sum"] += memo[cache_key]
            continue
        
        # Base case: no sheep left
        if state["sheep"].is_empty():
            memo[cache_key] = 1
            if not call_stack.is_empty():
                var parent: Dictionary = call_stack.pop_back()
                parent["sum"] += 1
            continue
        
        # Check if any sheep have clear path to bottom
        var has_losing_sheep: bool = false
        for pos: Variant in state["sheep"]:
            var sheep_pos: Vector2i = pos as Vector2i
            var has_clear_path: bool = true
            for k: int in range(sheep_pos.y, grid_size):
                if grid[k][sheep_pos.x] != '#':
                    has_clear_path = false
                    break
            if has_clear_path:
                has_losing_sheep = true
                break
        
        if has_losing_sheep:
            memo[cache_key] = 0
            if not call_stack.is_empty():
                var parent: Dictionary = call_stack.pop_back()
                parent["sum"] += 0
            continue
        
        # Create accumulator for this state
        var accumulator: Dictionary = {"sum": 0, "cache_key": cache_key, "pending": 0}
        
        if state["turn"] == 0:  # Sheep's turn
            var any_sheep_moved: bool = false
            
            for pos: Variant in state["sheep"]:
                var sheep_pos: Vector2i = pos as Vector2i
                var j: int = sheep_pos.x
                var i: int = sheep_pos.y
                
                var can_move: bool = true
                if i >= grid_size - 1:
                    can_move = false
                elif Vector2i(j, i + 1) == Vector2i(state["x"], state["y"]):
                    can_move = false
                elif grid[i + 1][j] == '#':
                    can_move = false
                
                if can_move:
                    var temp_sheep: Set = Set.new()
                    for other_pos: Variant in state["sheep"]:
                        var other: Vector2i = other_pos as Vector2i
                        if other != sheep_pos:
                            temp_sheep.add(other)
                    temp_sheep.add(Vector2i(j, i + 1))
                    
                    accumulator["pending"] += 1
                    call_stack.push_back(accumulator)
                    stack.push_back({"x": state["x"], "y": state["y"], "sheep": temp_sheep, "turn": 1, "depth": state["depth"] + 1})
                    any_sheep_moved = true
            
            if not any_sheep_moved:
                accumulator["pending"] += 1
                call_stack.push_back(accumulator)
                stack.push_back({"x": state["x"], "y": state["y"], "sheep": state["sheep"], "turn": 1, "depth": state["depth"]})
        
        else:  # Dragon's turn
            for knight_move: Vector2i in MOVES:
                var new_x: int = state["x"] + knight_move.x
                var new_y: int = state["y"] + knight_move.y
                
                if new_x >= 0 and new_x < grid_size and new_y >= 0 and new_y < grid_size:
                    var new_sheep: Set = Set.new()
                    for pos: Variant in state["sheep"]:
                        new_sheep.add(pos)
                    
                    var target_pos: Vector2i = Vector2i(new_x, new_y)
                    if state["sheep"].contains(target_pos) and grid[new_y][new_x] != '#':
                        new_sheep.remove(target_pos)
                    
                    accumulator["pending"] += 1
                    call_stack.push_back(accumulator)
                    stack.push_back({"x": new_x, "y": new_y, "sheep": new_sheep, "turn": 0, "depth": state["depth"] + 1})
        
        # If no children were added, we can memoize immediately
        if accumulator["pending"] == 0:
            memo[cache_key] = 0
    
    # Process any remaining accumulators
    while not call_stack.is_empty():
        var acc: Dictionary = call_stack.pop_back()
        memo[acc["cache_key"]] = acc["sum"]
    
    return memo.get(get_cache_key(start_x, start_y, start_sheep, 0), 0)

#endregion

func part1(data: String, ans: LineEdit) -> void:
    var grid: Array[Array] = ECodes.string_to_2d_char_array(data)
    var dimensions: Vector2i = ECodes.dimensions_of_2d_array(grid)
    var sheep: Set = Set.new()
    var visited: Set = Set.new()
    var dragon: Vector2i = Vector2i.ZERO
    
    for y: int in range(dimensions.y):
        for x: int in range(dimensions.x):
            if grid[y][x] == "D":
                dragon = Vector2i(y,x)
            if grid[x][y] == "S":
                sheep.add(Vector2i(y,x))
    visited.add(dragon)        
    debug_print(dragon)
    debug_print("Sheep",sheep)

    var moves: int = 4
    if debug:
        moves = 3

    
    for i: int in range(moves):
        visited = move(visited)
        debug_print(i, visited)
    
    
    
    var intersection : Set = visited.intersection(sheep)
    debug_print("Intersection",intersection)
    ans.text = str(intersection.size())
    
    
func part2(data: String, ans: LineEdit) -> void:
    var rounds: int = 20
    if debug:
        rounds = 3
        
    var retval: int = 0    
    var grid: Array[Array] = ECodes.string_to_2d_char_array(data)
    var dimensions: Vector2i = ECodes.dimensions_of_2d_array(grid)
    var sheep: Set = Set.new()
    var safe: Set = Set.new()
    var dragons: Set = Set.new()
    var dragon: Vector2i = Vector2i.ZERO
    for y: int in range(dimensions.y):
        for x: int in range(dimensions.x):
            if grid[y][x] == "D":
                dragon = Vector2i(y,x)
            if grid[x][y] == "S":
                sheep.add(Vector2i(y,x))
            if grid[x][y] == "#":
                safe.add(Vector2i(y,x))
                
    dragons.add(dragon)
    for _r: int in range(rounds):
        dragons = dragon_move(dragons, dimensions.x)
        var eaten: Set = sheep.difference(safe).intersection(dragons)
        debug_print(eaten)
        retval += eaten.size()
        sheep = sheep.difference(eaten)
        sheep = sheep_move(sheep,dimensions.x)
        eaten = sheep.difference(safe).intersection(dragons)
        retval += eaten.size()
        sheep = sheep.difference(eaten)
        
             
    ans.text = str(retval)


func part3(data: String, ans: LineEdit) -> void:
    var grid: Array[String] = []
    var lines: PackedStringArray = data.split("\n")
    for line: String in lines:
        if line != "":
            grid.append(line)
    
    var grid_size: int = grid[0].length()
    
    # Find dragon position (D) and sheep positions (S)
    var dragon_x: int = 0
    var dragon_y: int = 0
    var sheep_set: Set = Set.new()
    
    for i: int in range(grid_size):
        var line: String = grid[i]
        for j: int in range(grid_size):
            var c: String = line[j]
            if c == 'D':
                dragon_x = j
                dragon_y = i
            elif c == 'S':
                sheep_set.add(Vector2i(j, i))
    
    var result: int = calculate_paths_iterative(grid, grid_size, dragon_x, dragon_y, sheep_set)
    ans.text = str(result)
    
    ans.text = str(grid.size())
