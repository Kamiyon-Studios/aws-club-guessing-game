extends ProgressBar

var quiz_ui_script
var timer_value: float = 0.0
var elapsed_time: float = 0.0
var is_countdown: bool

func _ready():
	# Connect to the signal emitted when a question is shown
	quiz_ui_script = get_parent()
	quiz_ui_script.connect("on_question_show", Callable(self, "_update_progress_bar"))
	quiz_ui_script.connect("on_answer_action", Callable(self, "_stop_progress_bar"))
	quiz_ui_script.connect("on_quiz_finish", Callable(self, "_stop_timer_completely"))

func _process(delta):
	# Update progress bar if there's a timer active
	if is_countdown:
		if timer_value > 0:
			elapsed_time += delta
			var remaining_time = max(0, timer_value - elapsed_time)
			#self.value = (remaining_time / timer_value) * 100

			# Update the shader parameter
			var shader_material := self.material
			if shader_material and shader_material is ShaderMaterial:
				shader_material.set_shader_parameter("progress", remaining_time / timer_value)

			# Stop updating if time runs out
			if remaining_time <= 0:
				timer_value = 0 # Ensure the timer doesn't go negative

func _update_progress_bar():
	# Initialize the timer and progress bar
	is_countdown = true
	timer_value = quiz_ui_script.timer_value
	elapsed_time = 0.0
	self.value = 100 # Reset the progress bar to full

	# Reset shader parameter
	var shader_material := self.material
	if shader_material and shader_material is ShaderMaterial:
		shader_material.set_shader_parameter("progress", 1.0)

func _stop_progress_bar():
	is_countdown = false

func _stop_timer_completely():
	set_process(false)
	print("Timer stopped")
