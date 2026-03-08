extends MarginContainer


#region Constants
const GAME_START := preload("uid://jla2pprv03ge")
const OPTION_PRESS := preload("uid://51s3xertyupg")


const CREDITS_SCENE_PATH := "res://src/main/main_menu/credits/credits_screen.tscn"
const SETTINGS_SCENE_PATH := "res://src/main/main_menu/settings/settings_screen.tscn"
const STORY_SCENE_PATH := "res://src/main/main_menu/story/story_screen.tscn"
#endregion



#region Private Methods (On Signal)
func _start_game_pressed() -> void:
	SoundManager.create_sound_effect(GAME_START)
	Global.main_controller.load_game()

func _credits_game_pressed() -> void:
	SoundManager.create_sound_effect(OPTION_PRESS)
	Global.local_controller.change_scene_to_path(
		CREDITS_SCENE_PATH
	)
func _settings_game_pressed() -> void:
	SoundManager.create_sound_effect(OPTION_PRESS)
	Global.local_controller.change_scene_to_path(
		SETTINGS_SCENE_PATH
	)
func _story_game_pressed() -> void:
	SoundManager.create_sound_effect(OPTION_PRESS)
	Global.local_controller.change_scene_to_path(
		STORY_SCENE_PATH,
		1.5, 0.5
	)

func _quit_game_pressed() -> void:
	get_tree().quit()
#endregion
