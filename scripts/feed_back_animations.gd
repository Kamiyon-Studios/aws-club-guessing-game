extends Control

# Animations
@export_category("Animations")
@export var feedback_animation_player: AnimationPlayer
@export var mascot_animation_player: AnimationPlayer

@export_category("SFX")
@export var mascot_sfx_player: AudioStreamPlayer

# Script
@export var quiz_ui_script: Node

# Animation arrays
var correct_mascot_animation: Array[String] = ["Correct_Feedback1", "Correct_Feedback2"]
var incorrect_mascot_animation: Array[String] = ["Incorrect_Feedback1", "Incorrect_Feedback2"]

# SFX array
var correct_mascot_sfx: Array[AudioStream] = [
	preload("res://assets/Sounds/sfx_reaction/sfx_mascot_happy_1.mp3"),
	preload("res://assets/Sounds/sfx_reaction/sfx_mascot_happy_2.mp3"),
	preload("res://assets/Sounds/sfx_reaction/sfx_mascot_shocked.mp3"),
	preload("res://assets/Sounds/sfx_reaction/sfx_mascot_shocked_2.mp3"),
]

var incorrect_mascot_sfx: Array[AudioStream] = [
	preload("res://assets/Sounds/sfx_reaction/sfx_mascot_crying_1.mp3"),
	preload("res://assets/Sounds/sfx_reaction/sfx_mascot_crying_2.mp3"),
	preload("res://assets/Sounds/sfx_reaction/sfx_mascot_sad_1.mp3"),
	preload("res://assets/Sounds/sfx_reaction/sfx_mascot_sad_2.mp3"),
]

func _init() -> void:
	hide()

func _ready() -> void:
	# Connect next question signal
	quiz_ui_script.connect("on_next_question", Callable(self, "reset_mascot_animation"))
	
	# Connect answer signals
	quiz_ui_script.connect("on_correct_answer", Callable(self, "_on_correct_answer"))
	quiz_ui_script.connect("on_incorrect_answer", Callable(self, "_on_incorrect_answer"))
	quiz_ui_script.connect("on_timeout", Callable(self, "_on_timeout"))
	
	# Connect animation finished signal

	feedback_animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _on_correct_answer() -> void:
	show()
	# Get a random correct animation
	var random_correct_anim = correct_mascot_animation[randi() % correct_mascot_animation.size()]
	# Play the animation
	mascot_animation_player.play(random_correct_anim)
	# Play the correct feedback animation
	feedback_animation_player.play("Correct_Feedback")
	_play_random_mascot_sfx(correct_mascot_sfx)

func _on_incorrect_answer() -> void:
	show()
	# Get a random incorrect animation
	var random_incorrect_anim = incorrect_mascot_animation[randi() % incorrect_mascot_animation.size()]
	# Play the animation
	mascot_animation_player.play(random_incorrect_anim)
	# Play the incorrect feedback animation
	feedback_animation_player.play("Incorrect_Feedback")
	_play_random_mascot_sfx(incorrect_mascot_sfx)

func _on_timeout() -> void:
	show()
	# Get a random incorrect animation
	var random_incorrect_anim = incorrect_mascot_animation[randi() % incorrect_mascot_animation.size()]
	# Play the animation
	mascot_animation_player.play(random_incorrect_anim)
	feedback_animation_player.play("Timeout_Feedback")
	_play_random_mascot_sfx(incorrect_mascot_sfx)

func _on_animation_finished(_anim_name: StringName) -> void:
	# Hide the animation
	hide()

func reset_mascot_animation() -> void:
	# Reset the animation
	mascot_animation_player.play("RESET")


func _play_random_mascot_sfx(sfx_array: Array[AudioStream]) -> void:
	var random_sfx = correct_mascot_sfx[randi() % sfx_array.size()]
	mascot_sfx_player.stream = random_sfx
	mascot_sfx_player.play()
