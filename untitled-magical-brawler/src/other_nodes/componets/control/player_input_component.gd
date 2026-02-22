class_name PlayerInputComponent extends Node


#region Public Methods
func left_press() -> bool:
	return Input.is_action_pressed(&"player_left")
func right_press() -> bool:
	return Input.is_action_pressed(&"player_right")
func up_press() -> bool:
	return Input.is_action_pressed(&"player_up")
func down_press() -> bool:
	return Input.is_action_pressed(&"player_down")

func activate_ability() -> bool:
	return Input.is_action_pressed(&"player_ability")
func activate_ability_select() -> bool:
	return Input.is_action_pressed(&"player_ability_select")
#endregion
