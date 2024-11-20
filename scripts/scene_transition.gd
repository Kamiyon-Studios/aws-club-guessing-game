extends Control

# Exported AnimationPlayer and Animation Node references
@export var animation_player: AnimationPlayer
@export var animation_node: Node

# Signals
signal enter_animation_finished
signal exit_animation_finished
signal onscreen_animation_finished

func _ready() -> void:
    # Connect the animation_finished signal to the custom handler
    animation_player.animation_finished.connect(Callable(self, "_on_animation_finished"))

# Handle when the animation finishes
# Add an argument to receive the name of the finished animation
func _on_animation_finished(anim_name: String) -> void:
    match anim_name:
        "Scene_Transition_Enter":
            enter_animation_finished.emit()
        "Scene_Transition_Exit":
            exit_animation_finished.emit()
        "Scene_Transition_OnScreen":
            onscreen_animation_finished.emit()

# Play a transition animation (Enter)
func play_transition_enter() -> void:
    animation_player.play("Scene_Transition_Enter")

# Play a transition animation (Exit)
func play_transition_exit() -> void:
    animation_player.play("Scene_Transition_Exit")

# Play a transition animation (Onscreen)
func play_transition_onscreen() -> void:
    animation_player.play("Scene_Transition_OnScreen")
