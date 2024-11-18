extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer
const TITLE_SCREEN = preload("res://scenes/title_screen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play()
	get_tree().change_scene(TITLE_SCREEN)
