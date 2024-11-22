extends Control

signal countdown_finished

@export var countdown_animation_player: AnimationPlayer
@export var mechanics_ui: Node
@export var quiz_ui_script: Node

func _ready():
	mechanics_ui.connect("on_game_start", Callable(self, "_start_countdown"))
	countdown_animation_player.connect("animation_finished", Callable(self, "_start_game"))

func _start_countdown():
	show()
	countdown_animation_player.play("Start_Countdown")

func _start_game(_anim_name: StringName):
	countdown_finished.emit()
