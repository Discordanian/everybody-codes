extends Control

@onready var grid: GridContainer = $MarginContainer/VBoxContainer/ButtonGrid

func exists_scene(day: int) -> bool:
    var scene_path: String = "res://scenes/day_%02d.tscn" % day
    return ResourceLoader.exists(scene_path)


func _on_day_button_pressed(day: int) -> void:
    var scene_path: String = "res://scenes/day_%02d.tscn" % day
    
    if exists_scene(day):
        print("Loading scene for day %02d: %s" % [day,scene_path])
        
        var scene_resource: PackedScene = load(scene_path)
        if scene_resource:
            get_tree().change_scene_to_packed(scene_resource)
        else:
            push_error("Error loading scene!")
    else:
        push_error("Told to load non existant scene")				

func create_day_buttons() -> void:
    for i: int in range(20):
        if i > 0:
            var b: Button = Button.new()
            b.text = "Day %02d" % i
            b.disabled = not exists_scene(i)
            b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
            b.size_flags_vertical = Control.SIZE_EXPAND_FILL
            grid.add_child(b)
            b.pressed.connect(_on_day_button_pressed.bind(i))
    

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    create_day_buttons()    
