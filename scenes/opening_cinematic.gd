"""
	By Stingray
"""

extends Node2D

@export var cinematic: AnimationPlayer
@export var autoplay : bool = false
@export var next_scene : PackedScene
@onready var cinematic_audio: AudioStreamPlayer = $CinematicAudio


func _on_cinematic_animation_finished(anim_name: StringName) -> void:
	change_scene()


func pause():
	if autoplay == false:
		cinematic.pause()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("break") and cinematic.is_playing():
		print("Skipped Cinematic :(")
		var target_time = cinematic.current_animation_length - 0.25
		target_time = max(0.0, target_time)  # safety for very short animations
		cinematic.seek(target_time, true)    # true = update immediately
		cinematic_audio.stop()


func change_scene() -> void:
	get_tree().change_scene_to_packed(next_scene)
