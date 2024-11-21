extends Control

@export_category("Start Buttons")
@export var start_button1: TextureButton
@export var start_button2: TextureButton

@export_category("Quiz_UI")
@export var quiz_ui_script: Node

func _ready() -> void:
	start_button1.connect("pressed", Callable(quiz_ui_script, "set_target_question_JSON").bind(1))
	start_button2.connect("pressed", Callable(quiz_ui_script, "set_target_question_JSON").bind(2))

	start_button1.connect("pressed", Callable(self, "_disable_buttons"))
	start_button2.connect("pressed", Callable(self, "_disable_buttons"))

func _disable_buttons() -> void:
	start_button1.disabled = true
	start_button2.disabled = true
	hide()