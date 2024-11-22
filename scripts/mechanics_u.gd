extends Control

signal on_game_start
@onready var sfx_buttons: AudioStreamPlayer = $sfx_buttons

@export_category("Start Buttons")
@export var start_button1: TextureButton
@export var start_button2: TextureButton

@export_category("Quiz_UI")
@export var quiz_ui_script: Node

func _ready() -> void:
	start_button1.connect("pressed", Callable(quiz_ui_script, "set_target_question_JSON").bind(1))
	start_button2.connect("pressed", Callable(quiz_ui_script, "set_target_question_JSON").bind(2))

	start_button1.connect("pressed", Callable(self, "_game_start"))
	start_button2.connect("pressed", Callable(self, "_game_start"))

func _game_start() -> void:
	on_game_start.emit()
	start_button1.disabled = true
	start_button2.disabled = true
	hide()


func _on_btn_facts_pressed() -> void:
	sfx_buttons.play()


func _on_btn_trivia_pressed() -> void:
	sfx_buttons.play()
