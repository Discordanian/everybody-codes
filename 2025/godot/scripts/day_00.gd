extends Control

@export var day: int = 0
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
    example_path1 = ECodes.example_path1(year,day)
    example_path2 = ECodes.example_path1(year,day)
    print("Input Part 1", FileAccess.file_exists("../everybody_codes_e2025_q01_p1.txt"))
    setup_example()

        
    
func part1(data: String, ans: LineEdit) -> void:
    var answer: String
    answer = str(ECodes.string_to_lines(data).size())
    ans.text = answer
    
    
func part2(data: String, ans: LineEdit) -> void:
    var answer: String
    print("Part2",data)
    answer = str(ECodes.dimensions_of_2d_array(ECodes.string_to_2d_char_array(data)))
    ans.text = answer


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
    var data1: String = ECodes.string_from_file(ECodes.input_path(2024, 10, 1))
    var data2: String = ECodes.string_from_file(ECodes.input_path(2024, 10, 2))
    part1(data1, answer1)
    part2(data2, answer2)


func _on_main_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/main_entry.tscn") 
