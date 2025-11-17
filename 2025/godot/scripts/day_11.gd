extends Control

@export var day: int = 11
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

func checksum(d: Array[int]) -> int:
    var retval: int = 0
    for idx: int in range(d.size()):
        retval += (idx + 1) * d[idx]
    return retval
    

func part1(data: String, ans: LineEdit) -> void:
    var ducks: Array[int] = ECodes.array_int_from_string(data)
    
    var phase: int = 1
    var numcols: int = ducks.size()
    var counter: int = 0
    while phase == 1:
        counter += 1
        phase = 2
        debug_print(ducks)
        for idx: int in range(numcols - 1):
            if ducks[idx] > ducks[idx+1]:
                phase = 1
                ducks[idx] -= 1
                ducks[idx+1] += 1
    debug_print("Phase 2")
    while counter < 11:
        debug_print(ducks)    
        counter += 1
        for idx: int in range(numcols - 1):
            if ducks[idx] < ducks[idx+1]:
                ducks[idx] += 1
                ducks[idx+1] -= 1
    ans.text = str(checksum(ducks))
    
    
func part2(data: String, ans: LineEdit) -> void:
    var ducks: Array[int] = ECodes.array_int_from_string(data)
    var phase: int = 1
    var numcols: int = ducks.size()
    var counter: int = 0
    while phase == 1:
        counter += 1
        phase = 2
        debug_print("Part 2", ducks)
        for idx: int in range(numcols - 1):
            if ducks[idx] > ducks[idx+1]:
                phase = 1
                ducks[idx] -= 1
                ducks[idx+1] += 1
    counter -= 1
    debug_print("Part 2 Phase 2")
    while phase == 2:
        debug_print(ducks)    
        counter += 1
        phase = 3
        for idx: int in range(numcols - 1):
            if ducks[idx] < ducks[idx+1]:
                phase = 2
                ducks[idx] += 1
                ducks[idx+1] -= 1
    
    ans.text = str(counter - 1)

# Different tack.  Input was sorted so really only worried about time on phase 2
func part3(data: String, ans: LineEdit) -> void:
    var ducks: Array[int] = ECodes.array_int_from_string(data)
    var retval: int = 0
    var total: int = 0
    for d: int in ducks:
        total += d
    var avg: int = total / ducks.size()
    for d: int in ducks:
        if d < avg:
            retval += (avg - d)   
    ans.text = str(retval)

func part3x(data: String, ans: LineEdit) -> void:
    var ducks: Array[int] = ECodes.array_int_from_string(data)
    var phase: int = 1
    var numcols: int = ducks.size()
    var counter: int = 0
    while phase == 1:
        counter += 1
        phase = 2
        debug_print("Part 2", ducks)
        for idx: int in range(numcols - 1):
            if ducks[idx] > ducks[idx+1]:
                phase = 1
                ducks[idx] -= 1
                ducks[idx+1] += 1
    counter -= 1
    debug_print("Part 2 Phase 2")
    while phase == 2:
        debug_print(ducks)    
        counter += 1
        phase = 3
        for idx: int in range(numcols - 1):
            if ducks[idx] < ducks[idx+1]:
                phase = 2
                ducks[idx] += 1
                ducks[idx+1] -= 1
    
    ans.text = str(counter - 1)
