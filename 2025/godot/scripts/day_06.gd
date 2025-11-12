extends Control

@export var day: int = 6
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
    part3ex(data3, example3)
    
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
        part3input(ECodes.string_from_file(path3), answer3)


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

func part1(data: String, ans: LineEdit) -> void:
    var len: int = data.length()
    var mentors: Array[int] = []
    var novices: Array[int] = []
    var retval: int = 0
    for idx: int in range(len):
        if data[idx] == "A":
            mentors.append(idx)
        if data[idx] == "a":
            novices.append(idx)
    for novice: int in novices:
        retval += mentors.filter(func(mentor: int) -> bool: return mentor < novice).size()
        
    ans.text = str(retval)

func is_novice(s: String) -> bool:
    return s.to_lower() == s    

func mentor_count(source: String, type: String) -> int:
    return source.count(type.to_upper())
    
func part2(data: String, ans: LineEdit) -> void:
    var retval: int = 0
    for idx: int in range(data.length()):
        var x: String = data[idx]
        if is_novice(x):
            retval += mentor_count(data.substr(0, idx),x)
            
    
    
    ans.text = str(retval)

func part3input(data: String, ans: LineEdit) -> void:
    const MAP_PERIOD: int = 1000
    const MENTOR_WINDOW: int = 1000
    
    var retval: int = 0
    
    # First loop: process first MENTOR_WINDOW characters
    for i:int in range(MENTOR_WINDOW):
        if not data[i].to_upper() == data[i]:
            var lowercase_char: String = data[i]
            var uppercase_char: String = lowercase_char.to_upper()
            var substring: String = data.substr(data.length() - MENTOR_WINDOW + i)
            retval += substring.count(uppercase_char)
        
        if not data[data.length() - 1 - i].to_upper() == data[data.length() - 1 - i]:
            var lowercase_char: String = data[data.length() - 1 - i]
            var uppercase_char: String = lowercase_char.to_upper()
            var substring: String = data.substr(0, MENTOR_WINDOW - i)
            retval += substring.count(uppercase_char)
    
    retval *= MAP_PERIOD - 1
    
    # Second loop: process all characters
    for i:int in range(data.length()):
        if data[i].to_upper() == data[i]:
            continue
        
        var lowercase_char: String = data[i]
        var uppercase_char: String = lowercase_char.to_upper()
        var start: int = max(0, i - MENTOR_WINDOW)
        var length: int = min(data.length(), i + MENTOR_WINDOW + 1) - start
        var substring: String = data.substr(start, length)
        retval += substring.count(uppercase_char) * MAP_PERIOD
    
    ans.text = str(retval)



func part3ex(data: String, ans: LineEdit) -> void:
    var bigdata: String = ""
    var retval: int = 0
    for _i: int in range(1000):
        bigdata += data

    for idx: int in range(bigdata.length()):
        var x: String = bigdata[idx]
        if is_novice(x):
            var start_idx: int = max(0, idx-1000)
            var stop_idx: int = min(idx + 1001, bigdata.length())
            retval += mentor_count(bigdata.substr(start_idx, stop_idx),x)
            
        
    
    ans.text = str(retval)
