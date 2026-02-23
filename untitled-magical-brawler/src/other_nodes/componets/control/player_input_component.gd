class_name PlayerInputComponent extends Node


#region Public Methods
# Base Controls
func left_press() -> bool:
	return Input.is_action_pressed(&"player_left")
func right_press() -> bool:
	return Input.is_action_pressed(&"player_right")
func up_press() -> bool:
	return Input.is_action_pressed(&"player_up")
func down_press() -> bool:
	return Input.is_action_pressed(&"player_down")

# Special Controls
func jump_press() -> bool:
	return Input.is_action_pressed(&"player_jump")
func attack_press() -> bool:
	return Input.is_action_pressed(&"player_attack")

# Ability Controls
func activate_ability() -> bool:
	return Input.is_action_pressed(&"player_ability")
func activate_ability_select() -> bool:
	return Input.is_action_pressed(&"player_ability_select")
#endregion
