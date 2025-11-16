"""
	This code is to randomize the Rubble texture item per instantiation
	By : Stingray
"""

extends Node2D

const rubble_folder := "res://data/2D assets/world/rubble sprites/"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rubble: Sprite2D = $Rubble/Rubble

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize_sprite()

func randomize_sprite() -> void:
	var png_paths := _list_png_files(rubble_folder)
	if png_paths.is_empty():
		push_error("No PNG files found in %s" % rubble_folder)
		return
	
	var chosen_path: String = png_paths.pick_random()
	var texture := load(chosen_path) as Texture2D
	if texture:
		rubble.texture = texture
	else:
		push_error("Failed to load texture: %s" % chosen_path)
	

func _list_png_files(folder_path: String) -> Array[String]:
	var files: Array[String] = []
	var dir := DirAccess.open(folder_path)
	
	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.get_extension().to_lower() == "png":
				files.append(folder_path.path_join(file_name))
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		push_error("Cannot open folder: %s" % folder_path)
		
	return files


func rubble_fall() -> void:
	animation_player.play("RESET")
