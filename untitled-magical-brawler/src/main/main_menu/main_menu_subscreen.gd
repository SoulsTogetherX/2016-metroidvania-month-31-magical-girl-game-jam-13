extends MarginContainer


#region Constants
const START_SCENE_PATH := "res://src/main/main_menu/start_screen/start_screen.tscn"
#endregion



#region Private Methods (On Signal)
func _on_back() -> void:
	Global.local_controller.change_scene_to_path(
		START_SCENE_PATH
	)
#endregion
