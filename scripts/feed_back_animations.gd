extends Control

@export_category("Animations")
@export var feedback_animation_player: AnimationPlayer

@export var quiz_ui_script: Node

func _ready() -> void:
	quiz_ui_script.connect("on_correct_answer", Callable(self, "_on_correct_answer"))
	quiz_ui_script.connect("on_incorrect_answer", Callable(self, "_on_incorrect_answer"))
	quiz_ui_script.connect("on_timeout", Callable(self, "_on_timeout"))

	feedback_animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

	hide()

func _on_correct_answer() -> void:
	show()
	feedback_animation_player.play("Correct_Feedback")

func _on_incorrect_answer() -> void:
	show()
	feedback_animation_player.play("Incorrect_Feedback")

func _on_timeout() -> void:
	pass

func _on_animation_finished(_anim_name: StringName) -> void:
	hide()
