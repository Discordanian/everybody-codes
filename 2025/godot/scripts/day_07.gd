extends Control

@export var day: int = 7
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
    $MarginContainer/VBoxContainer/Header/Label.text = "Everybody Codes Q %02d" % [day]
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

func valid_name(n: String, map: Dictionary) -> bool:
    for idx: int in range(n.length() - 1):
        var key: String = n[idx]
        var target: String = n[idx + 1]
        if not map.has(key):
            return false
        if not map[key].has(target):
            return false
    return true

func number_possible(n: String, map: Dictionary) -> int:
    if not valid_name(n, map):
        return 0
    if n.length() > 11:
        return 0
    var last_letter: String = n[n.length() - 1]
    if not map.has(last_letter):
        return 0
    var extra: PackedStringArray = map[last_letter]
    var sum: int = 0
    for c: String in extra:
        var dance_mix_name: String = n + c
        sum += number_possible(dance_mix_name, map)
    if n.length() > 6:
        sum += extra.size()
    return sum
        

func part1(data: String, ans: LineEdit) -> void:
    var lines: PackedStringArray = ECodes.string_to_lines(data.strip_edges())
    var names: PackedStringArray = lines[0].split(",")
    var retval: String = ""
    var map: Dictionary = {}
    for i: int in range(lines.size()):
        if i < 2:
            continue
        var arrow: PackedStringArray = lines[i].split(" > ")
        var key: String = arrow[0]
        var val: PackedStringArray = arrow[1].split(",")
        map[key] = val
    for n: String in names:
        if valid_name(n, map):
            retval = n  
    ans.text = retval
    


    
func part2(data: String, ans: LineEdit) -> void:
    var lines: PackedStringArray = ECodes.string_to_lines(data.strip_edges())
    var names: PackedStringArray = lines[0].split(",")
    var retval: int = 0
    var map: Dictionary = {}
    for i: int in range(lines.size()):
        if i < 2:
            continue
        var arrow: PackedStringArray = lines[i].split(" > ")
        var key: String = arrow[0]
        var val: PackedStringArray = arrow[1].split(",")
        map[key] = val
    for idx: int in range(names.size()):
        if valid_name(names[idx], map):
            retval += (1 + idx)
    
    ans.text = str(retval)


func part3(data: String, ans: LineEdit) -> void:
    var lines: PackedStringArray = ECodes.string_to_lines(data.strip_edges())
    var names: PackedStringArray = lines[0].split(",")
    var map: Dictionary = {}
    var name_set: Set = Set.new()
    var q: Array[String] = []
    var seen: Array[String] = []
    for i: int in range(lines.size()):
        if i < 2:
            continue
        var arrow: PackedStringArray = lines[i].split(" > ")
        var key: String = arrow[0]
        var val: PackedStringArray = arrow[1].split(",")
        map[key] = val


    for n: String in names:
        if valid_name:
            q.append(n)
    
    while not q.is_empty():
        var n: String = q.pop_front()
        if seen.has(n):
            continue
        if n.length() > 11:
            continue
        seen.append(n)
        if n.length() > 6:
            name_set.add(n)
        var last_char: String = n[n.length() - 1]
        if map.has(last_char):
            for next: String in map[last_char]:
                q.append(n + next)
    debug_print(name_set)
    ans.text = str(name_set.size())
