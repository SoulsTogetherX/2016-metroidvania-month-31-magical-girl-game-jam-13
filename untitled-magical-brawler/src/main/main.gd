extends SceneControllerManager


#region Constants
const MAIN_MENU_PATH := "res://src/main/main_menu/main_menu.tscn"
const MAIN_GAME_PATH := "res://src/main/main_game/main_game.tscn"
#endregion


#region Constants
@export_group("Internal")
@export var transition_cover : TransitionCover
#endregion



#region Virtual Methods
func _ready() -> void:
	Global.main_controller = self
	Global.transition_cover = transition_cover
	load_main_menu()
#endregion


#region Public Methods
func load_main_menu() -> void:
	SoundManager.swap_music(null)
	get_tree().paused = false
	
	await fade_cover()
	scene_controller.change_scene_to_path(
		MAIN_MENU_PATH
	)
	await unfade_cover()
func load_game() -> void:
	await fade_cover()
	scene_controller.change_scene_to_path(
		MAIN_GAME_PATH
	)
#endregion
