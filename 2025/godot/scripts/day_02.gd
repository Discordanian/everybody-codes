extends Control

@export var day: int = 2
@export var year: int = 2025

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

func complex_add(a: Vector2i, b: Vector2i) -> Vector2i:
    return Vector2i(a.x + b.x, a.y + b.y)

func complex_add64(lhs: Array[int], rhs: Array[int]) -> Array[int]:
    var retval: Array[int] = []
    retval.append(lhs[0] + rhs[0])
    retval.append(lhs[1] + rhs[1])
    return retval
    
    
func complex_multiply(a: Vector2i, b: Vector2i) -> Vector2i:
    return Vector2i(a.x * b.x - a.y * b.y, a.x * b.y + b.x * a.y )
    
func complex_multiply64(lhs: Array[int], rhs: Array[int]) -> Array[int]:
    var retval: Array[int] = []
    retval.append(rhs[0] * lhs[0] - rhs[1] * lhs[1])
    retval.append(rhs[0] * lhs[1] + rhs[1] * lhs[0])
    return retval

func complex_division(a: Vector2i, b: Vector2i) -> Vector2i:
    return Vector2i(a.x/b.x, a.y/b.y)

func complex_division64(rhs: Array[int], lhs: Array[int]) -> Array[int]:
    var retval: Array[int] = []
    retval.append(rhs[0]/lhs[0])
    retval.append(rhs[1]/lhs[1])
    return retval
        

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
    # print("Input Part 1: ", FileAccess.file_exists("../everybody_codes_e2025_q01_p1.txt"))
    setup_example()

func cycle(r: Vector2i, a: Vector2i) -> Vector2i:
    var retval: Vector2i = complex_multiply(r, r)
    retval = complex_division(retval, Vector2i(10,10))
    retval = complex_add(retval, a)
    return retval
 
func cycle64(r: Array[int], a: Array[int]) -> Array[int]:
    var retval: Array[int] = complex_multiply64(r, r)
    retval = complex_division64(retval, [100_000,100_000])
    retval = complex_add64(retval, a)
    return retval     
    
func part1(data: String, ans: LineEdit) -> void:
    var ints: Array[int] = ECodes.array_int_from_string(data)
    var a: Vector2i = Vector2i(ints[0], ints[1])
    var r: Vector2i = Vector2i(0, 0)
    r = cycle(r,a)
    r = cycle(r,a)
    r = cycle(r,a)
    ans.text = "[%d,%d]" % [r.x, r.y]
    

func good_cycle(a: Array[int]) -> int:
    var r: Array[int] = [0,0]
    for _i: int in range(100):
        r = cycle64(r, a)
        if abs(r[0]) > 1_000_000 or abs(r[1]) > 1_000_000:
            return 0
    return 1
    
func part2(data: String, ans: LineEdit) -> void:
    var a: Array[int] = ECodes.array_int_from_string(data)
    var good: int = 0
    for y: int in range(101):
        for x: int in range(101):
            good += good_cycle(complex_add64(a, [x*10, y*10]))
            


    ans.text = str(good) 


func part3(data: String, ans: LineEdit) -> void:
    var a: Array[int] = ECodes.array_int_from_string(data)
    var good: int = 0
    for y: int in range(1001):
        for x: int in range(1001):
            good += good_cycle(complex_add64(a, [x, y]))
            


    ans.text = str(good) 

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
    var data1: String = ECodes.string_from_file(example_path1)
    var data2: String = ECodes.string_from_file(example_path2)
    var data3: String = ECodes.string_from_file(example_path3)
    part1(data1, example1)
    part2(data2, example2)
    part3(data3, example3)
    
func _on_input_pressed() -> void:
    var path1: String = ECodes.input_path(year, day, 1)
    var path2: String = ECodes.input_path(year, day, 2)
    var path3: String = ECodes.input_path(year, day, 3)
    
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
