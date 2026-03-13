extends MarginContainer


#region Constants
const START_SCENE_PATH := "res://src/main/main_menu/start_screen/start_screen.tscn"
const BACK := preload("uid://csc0hj6yd8y0d")
#endregion



#region Private Methods (On Signal)
func _on_back() -> void:
	SoundManager.create_sound_effect(
		BACK
	)
	Global.local_controller.change_scene_to_path(
		START_SCENE_PATH
	)
#endregion
