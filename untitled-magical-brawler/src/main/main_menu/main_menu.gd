extends SceneControllerManager


#region Constants
const MENU_MUSIC_PRELOAD = preload("uid://cyq0r057op4qo")
const START_SCENE_PATH := "res://src/main/main_menu/start_screen/start_screen.tscn"
#endregion



#region Virtual Methods
func _ready() -> void:
	super()
	_on_ready_load()
	SoundManager.swap_music(MENU_MUSIC_PRELOAD)
#endregion


#region Private Methods
func _on_ready_load() -> void:
	scene_controller.change_scene_to_path(
		START_SCENE_PATH
	)
#endregion


#region Public Methods (Change)
func change_scene_to_path(
	path : String,
	fade_in : float = 0.2, fade_out : float = 0.2
) -> void:
	await fade_cover(fade_in)
	scene_controller.change_scene_to_path(
		path, SceneController.UNMOUNT_TYPE.REMOVE
	)
	await unfade_cover(fade_out)
#endregion
