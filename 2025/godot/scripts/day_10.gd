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
    
    
    ans.text = str(grid.size())
