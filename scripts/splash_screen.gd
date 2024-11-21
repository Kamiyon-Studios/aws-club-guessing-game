extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var main = preload("res://scenes/title_screen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play()

	
func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_packed(main)
