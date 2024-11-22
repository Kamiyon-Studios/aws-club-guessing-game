extends Control

@onready var win_panel: Panel = $win_panel
@onready var panel_background: TextureRect = $win_panel/panel_background
@onready var win_1_pic: TextureRect = $win_panel/panel_background/win1_pic
@onready var win_2_pic: TextureRect = $win_panel/panel_background/win2_pic
@onready var win_3_pic: TextureRect = $win_panel/panel_background/win3_pic
@onready var win_4_pic: TextureRect = $win_panel/panel_background/win4_pic
@onready var win_lbl: Label = $win_panel/panel_background/win_lbl

@onready var roulette_sound: AudioStreamPlayer = $roulette_sound

@export var is_spin: bool = false  # Determines if the spinner is active
@export var speed: int = 10       # Spin speed
@export var power: int = 2        # Spin power multiplier
@export var reward_position = 0   # The position where the spinner stops
signal sig_reward                 # Signal emitted when a reward is determined

var vat_pham = [
	{
		"name": "Dark blue",
		"from": 0,
		"to": 45,
		"item_code": 4,
		"item_name": "win4"
	},
	{
		"name": "Dark green",
		"from": 45,
		"to": 90,
		"item_code": 4,
		"item_name": "win4"
	},
	{
		"name": "Blue",
		"from": 90,
		"to": 135,
		"item_code": 4,
		"item_name": "win4"
	},
	{
		"name": "Yellow",
		"from": 135,
		"to": 180,
		"item_code": 1,
		"item_name": "win1"
	}, 
	{
		"name": "Purple",
		"from": 180,
		"to": 225,
		"item_code": 3,
		"item_name": "win3"
	},
	{
		"name": "Green",
		"from": 225,
		"to": 270,
		"item_code": 4,
		"item_name": "win4"
	},
	{
		"name": "Orange",
		"from": 270,
		"to": 315,
		"item_code": 4,
		"item_name": "win4"
	},
	{
		"name": "Pink",
		"from": 315,
		"to": 360,
		"item_code": 2,
		"item_name": "win2"
	}
]

func _on_btn_spin_pressed():
	roulette_sound.play()
	if not is_spin:  # Check if the spinner is not already spinning
		is_spin = true  # Set spinner state to active
		var tween = get_tree().create_tween().set_parallel(true)
		tween.connect("finished", func():
			# Called when the animation finishes
			var current_rotation = %front.rotation_degrees
			is_spin = false  # Allow user to spin again
			
			if current_rotation > 360:
				# Adjust rotation to prevent exceeding a full circle
				%front.rotation_degrees = fmod(current_rotation, 360)

			# Determine which item was selected based on the reward position
			var item_code = -1
			for item in vat_pham:
				if reward_position >= item.from - 22.5 and reward_position <= item.to - 22.5:
					print(item.name)  # Display the item's name
					item_code = item.item_code  # Set the item code
					break  # Exit loop once match is found

			# Call the function to display the prize
			if item_code != -1:
				winning_prize(item_code)
		)
		
		reward_position = randi_range(0, 360)  # Randomize the reward position
		
		# Animate the spinner to the reward position
		tween.tween_property(
			%front, "rotation_degrees",
			reward_position + 360 * speed * power, 3
		).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
		tween.finished

# Handle the prize display logic based on the item code
func winning_prize(item_code):
	# Ensure the panel and all related elements are visible
	win_panel.visible = true
	panel_background.visible = true  # Ensure the background is also visible
	win_lbl.visible = true
	
	# Hide all prize images initially
	win_1_pic.visible = false
	win_2_pic.visible = false
	win_3_pic.visible = false
	win_4_pic.visible = false
	
	# Match item_code to determine the prize
	match item_code:
		1:
			win_1_pic.visible = true
			win_lbl.text = "AWS PIN!"
		2:
			win_2_pic.visible = true
			win_lbl.text = "AWS PIN + LACE!!"
		3:
			win_3_pic.visible = true
			win_lbl.text = "AWS LACE!!"
		4:
			win_4_pic.visible = true
			win_lbl.text = "AWS BALLPEN!!"
		_:
			win_lbl.text = "No prize!"  # Fallback for any unexpected item_code

# Restart button function
func _on_btn_restart_pressed() -> void:
	print("Restart button pressed")
	var palit = preload("res://scenes/splash_screen.tscn")
	get_tree().change_scene_to_packed(palit)
