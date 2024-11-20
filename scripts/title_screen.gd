extends Control

@export var scene_transiton_manager: Node

@onready var music_title_screen: AudioStreamPlayer = $music_title_screen
@onready var anim_aws_logo: AnimationPlayer = $anim_aws_logo

func _ready() -> void:
	music_title_screen.play()
	anim_aws_logo.play()

	scene_transiton_manager.connect("enter_animation_finished", Callable(self, "_on_animation_finished"))

func _on_btn_new_game_pressed() -> void:
	scene_transiton_manager.play_transition_enter()

func _on_btn_credits_pressed() -> void:
	pass # Replace with function body

func _on_btn_options_pressed() -> void:
	pass # Replace with function body

func _on_btn_exit_pressed() -> void:
	print("Thank you for playing!")
	get_tree().quit()

func _on_animation_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/quiz_ui.tscn")
