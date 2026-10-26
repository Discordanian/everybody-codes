class_name DayBase
extends Control

@export var day: int = 0
@export var year: int = 2026

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
var _input_pending: int = 0
var _input_run_id: int = 0
var _input_task_ids: Array[int] = []

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
	example_path1 = ECodes.example_path(year, day, 1)
	example_path2 = ECodes.example_path(year, day, 2)
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

	example1.text = part1(data1)
	example2.text = part2(data2)
	example3.text = part3(data3)

func _on_input_pressed() -> void:
	if _input_pending > 0:
		return
	debug = false
	_input_run_id += 1
	var run_id: int = _input_run_id
	var jobs: Array[Dictionary] = []
	_queue_input_job(jobs, 1, answer1)
	_queue_input_job(jobs, 2, answer2)
	_queue_input_job(jobs, 3, answer3)
	_input_pending = jobs.size()
	if _input_pending == 0:
		return
	inputButton.disabled = true
	_input_task_ids.clear()
	for job: Dictionary in jobs:
		var part: int = job["part"]
		var data: String = job["data"]
		var task_id: int = WorkerThreadPool.add_task(_run_input_part.bind(run_id, part, data))
		_input_task_ids.append(task_id)


func _exit_tree() -> void:
	# Results from this run are discarded. The tasks themselves have to finish:
	# a running part is a method on this node, and freeing it mid-call is unsafe.
	_input_run_id += 1
	for task_id: int in _input_task_ids:
		WorkerThreadPool.wait_for_task_completion(task_id)
	_input_task_ids.clear()
	_input_pending = 0


func _queue_input_job(jobs: Array[Dictionary], part: int, target: LineEdit) -> void:
	var path: String = ECodes.input_path(year, day, part)
	if not FileAccess.file_exists(path):
		target.text = "Input file not found"
		return
	target.text = ""
	jobs.append({"part": part, "data": ECodes.string_from_file(path)})


func _run_input_part(run_id: int, part: int, data: String) -> void:
	var result: String = _solve_part(part, data)
	if run_id != _input_run_id:
		return
	_apply_input_result.call_deferred(run_id, part, result)


func _solve_part(part: int, data: String) -> String:
	match part:
		1:
			return part1(data)
		2:
			return part2(data)
		3:
			return part3(data)
		_:
			return ""


func _apply_input_result(run_id: int, part: int, result: String) -> void:
	if run_id != _input_run_id or not is_inside_tree():
		return
	match part:
		1:
			answer1.text = result
		2:
			answer2.text = result
		3:
			answer3.text = result
	_input_pending -= 1
	if _input_pending <= 0:
		_input_pending = 0
		inputButton.disabled = false


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

func part1(_data: String) -> String:
	push_error("part1 is not implemented for day %02d" % day)
	return ""


func part2(_data: String) -> String:
	push_error("part2 is not implemented for day %02d" % day)
	return ""


func part3(_data: String) -> String:
	push_error("part3 is not implemented for day %02d" % day)
	return ""
