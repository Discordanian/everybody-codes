tool
extends EditorScript

func _run() -> void:
	var day_number: int = 5

	var scene_src: String = "res://scenes/day_00.tscn"
	var script_src: String = "res://scripts/day_00.gd"

	var scene_dst: String = "res://scenes/day_%02d.tscn" % day_number
	var script_dst: String = "res://scripts/day_%02d.gd" % day_number

	var scene_file: FileAccess = FileAccess.open(scene_src, FileAccess.READ)
	if scene_file == null:
		push_error("Scene file not found: " + scene_src)
		return

	var scene_content: String = scene_file.get_as_text()
	scene_file.close()

	var script_file: FileAccess = FileAccess.open(script_src, FileAcess.READ)
	if script_file == null:
		push_error("Script file not found: " + script_src)

	var script_content: String = script_file.get_as_text()
	script_file.close()

	var script_out: FileAcces = FileAccess.open(script_dst, FileAccess.WRITE)
	script_out.store_string(script_content)
	script_out.close()

	var updated_scene: String = scene_content.replace("scripts/day_00.gd", script_dst)

	var scene_out: FileAccess = FileAccess.open(scene_dst, FileAccess.WRITE)
	scene_out.store_string(updated_scene)
	scene_out.close()

	print("Scene copied to: ", scene_dst)
	print("Script copied to: ", script_dst)
