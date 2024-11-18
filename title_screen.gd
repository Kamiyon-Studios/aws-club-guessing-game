extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.play()


func _on_btn_new_game_pressed() -> void:
	pass # Replace with function body.


func _on_btn_credits_pressed() -> void:
	pass # Replace with function body.


func _on_btn_options_pressed() -> void:
	pass # Replace with function body.


func _on_btn_exit_pressed() -> void:
	print("Thank you for playing!")
	get_tree().quit()
