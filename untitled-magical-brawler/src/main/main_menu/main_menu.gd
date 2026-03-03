extends SceneControllerManager


#region Constants
const START_SCENE_PATH := "res://src/main/main_menu/start_screen/start_screen.tscn"
#endregion



#region Virtual Methods
func _ready() -> void:
	super()
	_on_ready_load()
#endregion


#region Private Methods
func _on_ready_load() -> void:
	scene_controller.change_scene_to_path(
		START_SCENE_PATH
	)
#endregion


#region Public Methods (Change)
func change_scene_to_path(
	path : String
) -> void:
	await fade_cover()
	scene_controller.change_scene_to_path(
		path, SceneController.UNMOUNT_TYPE.REMOVE
	)
	await unfade_cover()
#endregion
