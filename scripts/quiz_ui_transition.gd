extends Node

@export var scene_transiton_manager: Node
@export var mechanics_ui: Control

func _ready() -> void:
	scene_transiton_manager.play_transition_onscreen()
	scene_transiton_manager.connect("onscreen_animation_finished", Callable(self, "_on_animation_finished"))

func _on_animation_finished() -> void:
	scene_transiton_manager.play_transition_exit()
	mechanics_ui.visible = true
