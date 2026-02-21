class_name PlayerInputComponent extends Node


#region Public Methods
func horizontal_moving() -> float:
	return Input.get_axis(&"player_left", &"player_right")
func jumping() -> bool:
	return Input.is_action_pressed(&"player_jump")
func activate_ability() -> bool:
	return Input.is_action_pressed(&"player_ability")
#endregion
