extends Control

# Signals
signal on_question_show
signal on_answer_action
signal on_quiz_finish

# Export variables
@export_category("Labels")
@export var question_label: Label
@export var timer_label: Label
@export var question_number_label: Label
@export var score_label: Label

@export_category("Choice Buttons")
@export var button_group: Array[TextureButton]
@export var button_labels: Array[Label] # Labels corresponding to each button in button_group

@export_category("Next Question Button")
@export var next_question_button: TextureButton
@export var next_question_button_label: Label

@export_category("Animations")
@export var scene_transiton_manager: Node

# Node references
@onready var timer: Timer = $Timer

# Variables
var question = []
var current_question_index: int = 0
var timer_value: int = 0
var correct_answer_index: int = 0
var max_question: int = 5
var score: int = 0

# Called when the scene is ready
func _ready() -> void:
	hide()
	_load_questions()

	# Connect button press events for each answer button
	for button in button_group:
		button.connect("pressed", Callable(self, "_on_choice_pressed").bind(button_group.find(button)))

	# Connect the "Next Question" button
	next_question_button.connect("pressed", Callable(self, "_show_next_question"))
	next_question_button.hide()

	connect("on_quiz_finish", Callable(self, "_on_quiz_finish"))

	scene_transiton_manager.connect("exit_animation_finished", Callable(self, "_on_scene_exit_animation_finished"))

# Load the questions from a JSON file
func _load_questions() -> void:
	var file = FileAccess.open("res://questions/Questions.json", FileAccess.READ)
	if file:
		question = JSON.parse_string(file.get_as_text())
		file.close()
		question.shuffle()
	else:
		print("Failed to open file or file does not exist")

# Show a question
func _show_question(index: int) -> void:
	var question_data = question[index]
	question_label.text = question_data["question"]
	timer_value = question_data["time"]
	correct_answer_index = question_data["answer"]

	question_number_label.text = "Question " + str(index + 1) + " / " + str(max_question)
	_update_timer_display()

	# Shuffle and assign choices to buttons and labels
	var choices = question_data["choices"].duplicate()
	var correct_answer = choices[correct_answer_index]
	choices.shuffle()
	correct_answer_index = choices.find(correct_answer)

	for i in range(button_group.size()):
		var button = button_group[i]
		var label = button_labels[i]

		# Reset button appearance and interactivity
		button.modulate = Color(1, 1, 1)
		button.mouse_filter = Control.MOUSE_FILTER_PASS

		# Update label text
		label.text = choices[i]

	on_question_show.emit()
	timer.start()

# Called when an answer button is pressed
func _on_choice_pressed(choice_index: int) -> void:
	on_answer_action.emit()
	timer.stop()

	var is_correct = (choice_index == correct_answer_index)
	if is_correct:
		score += 1

	score_label.text = "Score: " + str(score)
	_show_feedback(is_correct, choice_index)

	if current_question_index == max_question - 1:
		next_question_button_label.text = "Finish"

	next_question_button.show()

# Show the next question
func _show_next_question() -> void:
	if current_question_index + 1 < max_question and current_question_index + 1 < question.size():
		current_question_index += 1
		next_question_button.hide()
		_show_question(current_question_index)
	else:
		on_quiz_finish.emit()

# Update the timer display
func _update_timer_display() -> void:
	timer_label.text = str(timer_value)

# Called when the timer times out
func _on_timer_timeout() -> void:
	timer_value -= 1
	_update_timer_display()

	if timer_value <= 0:
		timer.stop()
		print("Time's up!")
		_disable_buttons()
		_show_feedback(false, correct_answer_index)
		next_question_button.show()

# Show feedback for the selected answer
func _show_feedback(is_correct: bool, choice_index: int) -> void:
	_disable_buttons()

	# Update selected button's appearance and correct answer
	var selected_button = button_group[choice_index]
	var selected_label = button_labels[choice_index]
	selected_button.modulate = Color(0, 1, 0) if is_correct else Color(1, 0, 0)
	selected_label.modulate = Color(0, 1, 0) if is_correct else Color(1, 0, 0)

	var correct_button = button_group[correct_answer_index]
	var correct_label = button_labels[correct_answer_index]
	correct_button.modulate = Color(0, 1, 0)
	correct_label.modulate = Color(0, 1, 0)

# Called when the quiz is finished
func _on_quiz_finish() -> void:
	hide()
	print("Game over! Final score: ", score)

func _on_scene_exit_animation_finished() -> void:
	show()

# Disable all answer buttons
func _disable_buttons() -> void:
	for button in button_group:
		button.mouse_filter = Control.MOUSE_FILTER_IGNORE
