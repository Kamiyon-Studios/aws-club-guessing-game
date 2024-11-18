extends Control
@onready var music_title_screen: AudioStreamPlayer = $music_title_screen
@onready var anim_aws_logo: AnimationPlayer = $anim_aws_logo


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_title_screen.play()
	anim_aws_logo.play()


func _on_btn_new_game_pressed() -> void:
	pass # Replace with function body.


func _on_btn_credits_pressed() -> void:
	pass # Replace with function body.


func _on_btn_options_pressed() -> void:
	pass # Replace with function body.


func _on_btn_exit_pressed() -> void:
	print("Thank you for playing!")
	get_tree().quit()
