extends Control

@export var day: int = 5
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
    debug = true
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


func spine_int_array(spine: Array[Array]) -> Array[int]:
    var retval: Array[int] = []
    for rib: Array[Variant] in spine:
        var num_str: String = ""
        for cell: Variant in rib:
            if not cell == null:
                num_str += str(cell)
        retval.append(int(num_str))
    return retval

## Return [id, quality, rib_int_array]
func quality(data: String) -> Array[Variant]:
    var numbers: Array[int] = ECodes.array_int_from_string(data)
    var spine: Array[Array] = []
    print(data)
    assert(numbers.size() > 2, "Should have recevied lots of numbers")
    var id: int = numbers.pop_front()
    print("Working on ID :", id)
    for number: int in numbers:
        if numbers.is_empty():
            spine.append([null, number, null])
            continue
        var placed: bool = false
        for rib: Array[Variant] in spine:
            if not placed and rib[0] == null and number < rib[1]:
                rib[0] = number
                placed = true
                continue
            if not placed and rib[2] == null and number > rib[1]:
                rib[2] = number
                placed = true
                continue
        if not placed:
            spine.append([null, number, null])
    var answer: String = ""
    for rib: Array[Variant] in spine:
        answer += str(rib[1])
    return [id, int(answer), spine_int_array(spine)]
    
func part1(data: String, ans: LineEdit) -> void:
    ans.text = str(quality(data)[1]) 
   
func part2(data: String, ans: LineEdit) -> void:
    var qualities: Array[int]
    var lines: PackedStringArray = ECodes.string_to_lines(data)
    for line: String in lines:
        if line.length() > 2:
            qualities.append(quality(line)[1])
    assert(qualities.size() > 1, "Should have more than 1 quality")
    qualities.sort()
    var answer: int = qualities.pop_back() - qualities.pop_front()
    ans.text = str(answer)


func fishbone_sort(lhs: Array[Variant], rhs: Array[Variant]) -> bool:
    if lhs[1] != rhs[1]:
        return rhs[1] > lhs[1]
    var max_idx: int = max(lhs[2].size(), rhs[2].size())
    for idx: int in range(max_idx):
        if lhs[2][idx] != rhs[2][idx]:
            return rhs[2][idx] > lhs[2][idx]
    if lhs[2].size() != rhs[2].size():
        return lhs[2].size() > rhs[2].size()
    return rhs[0] > lhs[0]
        


func part3(data: String, ans: LineEdit) -> void:
    var arr: Array[Variant] = []
    var sum: int = 0
    var lines: PackedStringArray = ECodes.string_to_lines(data)
    for line: String in lines:
        if line.length() > 2:
            arr.append(quality(line))

    arr.sort_custom(fishbone_sort)
    arr.reverse()
    for idx: int in range(arr.size()):
        sum += (idx +1) * arr[idx][0]
    
    ans.text = str(sum)
