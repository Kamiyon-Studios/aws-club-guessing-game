extends Control

@export_category("Labels")
@export var score_label: Label

@export_category("Buttons")
@export var retry_button: TextureButton
@export var main_menu_button: TextureButton

@export_category("Animations")
@export var scene_transiton_manager: Node

var quiz_ui_script

var main_menu: bool = false
var retry: bool = false

func _ready() -> void:
	quiz_ui_script = get_node("../MainQuizUI")
	quiz_ui_script.connect("on_quiz_finish", Callable(self, "_on_quiz_finish"))

	retry_button.connect("pressed", Callable(self, "_on_retry_button_pressed"))
	main_menu_button.connect("pressed", Callable(self, "_on_main_menu_button_pressed"))

	scene_transiton_manager.connect("enter_animation_finished", Callable(self, "_on_scene_enter_animation_finished"))
	hide()

func _on_retry_button_pressed() -> void:
	retry = true
	scene_transiton_manager.play_transition_enter()

func _on_main_menu_button_pressed() -> void:
	main_menu = true
	scene_transiton_manager.play_transition_enter()
	

func _on_quiz_finish() -> void:
	score_label.text = "Score: " + str(quiz_ui_script.score)
	show()

func _on_scene_enter_animation_finished() -> void:
	if main_menu:
		get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
	if retry:
		get_tree().reload_current_scene()
