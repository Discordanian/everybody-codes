extends Control

@export var day: int = 1
@export var year: int = 2025
@export var downloadInput: bool = true
@onready var answer1: LineEdit = $MarginContainer/VBoxContainer/Assignment/VBoxContainer/Answer1
@onready var answer2: LineEdit = $MarginContainer/VBoxContainer/Assignment/VBoxContainer/Answer2
@onready var example1: LineEdit = $MarginContainer/VBoxContainer/Assignment/VBoxContainer/ExAnswer1
@onready var example2: LineEdit = $MarginContainer/VBoxContainer/Assignment/VBoxContainer/ExAnswer2
@onready var exampleText: TextEdit = $MarginContainer/VBoxContainer/Assignment/Example/ExampleTextEdit
@onready var exampleText2: TextEdit = $MarginContainer/VBoxContainer/Assignment/Example/ExampleTextEdit2
@onready var inputData: CheckBox = $MarginContainer/VBoxContainer/Assignment/VBoxContainer/InputDataReady
@onready var exampleButton: Button = %ExampleRunButton
@onready var inputButton: Button = %InputRunButton


var example_path1: String
var example_path2: String

func check_for_input() -> void:
    inputData.button_pressed = FileAccess.file_exists(ECodes.input_path(year,day, 1))
    inputButton.disabled = !inputData.button_pressed

func setup_example() -> void:
    var content1: String =  ECodes.string_from_file(example_path1)
    var content2: String =  ECodes.string_from_file(example_path2)
    exampleText.text = content1
    exampleText2.text = content2
    exampleButton.disabled = !(exampleText.text.length() != 0 && exampleText2.text.length() != 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $MarginContainer/VBoxContainer/Header/Label.text = "Everybody Codes Day %02d" % [day]
    example_path1 = ECodes.example_path1(year,day)
    example_path2 = ECodes.example_path1(year,day)
    # print("Input Part 1: ", FileAccess.file_exists("../everybody_codes_e2025_q01_p1.txt"))
    setup_example()

func value_from_move(move: String) -> int:
    assert(move.length() > 1, "Move given was too short")
    
    var direction: String = move[0]
    var value_str: String = move.substr(1)
    var value: int = value_str.to_int()
    
    if direction == "L":
        return -value 
    return value       
    
func part1(data: String, ans: LineEdit) -> void:
    var d: PackedStringArray = ECodes.string_to_lines(data)
    if d.size() < 3:
        push_error(data)
    var names: PackedStringArray = d[0].split(",")
    var moves: PackedStringArray =  d[2].split(",")
    var pointer: int = 0
    
    var max_idx: int = names.size() - 1
    for move: String in moves:
        var v: int = value_from_move(move)
        pointer = clamp(pointer + v, 0, max_idx)
        
        
    ans.text = names[pointer]
    
    
func part2(data: String, ans: LineEdit) -> void:
    var d: PackedStringArray = ECodes.string_to_lines(data)
    if d.size() < 3:
        push_error(data)
    var names: PackedStringArray = d[0].split(",")
    var moves: PackedStringArray =  d[2].split(",")
    var pointer: int = 0
    var max_idx: int = names.size() 
    
    for move: String in moves:
        var v: int = value_from_move(move)
        pointer = AoCMath.euclidean_mod(pointer + v, max_idx)    
    
    
    ans.text = names[pointer]


func _on_example_text_edit_text_changed() -> void:
    exampleButton.disabled = exampleText.text.length() == 0 || exampleText.text.length() == 0
    var file: FileAccess = FileAccess.open(example_path1, FileAccess.WRITE)
    if file:
        file.store_string(exampleText.text)
        file.close()
    else:
        push_error("Error writing to " + example_path1)
    
func _on_example_text_edit_text_changed2() -> void:
    exampleButton.disabled = exampleText.text.length() == 0 || exampleText.text.length() == 0
    var file: FileAccess = FileAccess.open(example_path2, FileAccess.WRITE)
    if file:
        file.store_string(exampleText2.text)
        file.close()
    else:
        push_error("Error writing to " + example_path2)

func _on_example_pressed() -> void:
    var data1: String = ECodes.string_from_file(example_path1)
    var data2: String = ECodes.string_from_file(example_path2)
    part1(data1, example1)
    part2(data2, example2)
    
func _on_input_pressed() -> void:
    var data1: String = ECodes.string_from_file(ECodes.input_path(year, day, 1))
    var data2: String = ECodes.string_from_file(ECodes.input_path(year, day, 2))
    part1(data1, answer1)
    part2(data2, answer2)


func _on_main_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/main_entry.tscn") 
