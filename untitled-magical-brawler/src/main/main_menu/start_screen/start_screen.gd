extends MarginContainer


#region Constants
const CREDITS_SCENE_PATH := "res://src/main/main_menu/credits/credits_screen.tscn"
const SETTINGS_SCENE_PATH := "res://src/main/main_menu/settings/settings_screen.tscn"
const STORY_SCENE_PATH := "res://src/main/main_menu/story/story_screen.tscn"
#endregion



#region Private Methods (On Signal)
func _start_game_pressed() -> void:
	Global.main_controller.load_game()

func _credits_game_pressed() -> void:
	Global.local_controller.change_scene_to_path(
		CREDITS_SCENE_PATH
	)
func _settings_game_pressed() -> void:
	Global.local_controller.change_scene_to_path(
		SETTINGS_SCENE_PATH
	)
func _story_game_pressed() -> void:
	Global.local_controller.change_scene_to_path(
		STORY_SCENE_PATH
	)

func _quit_game_pressed() -> void:
	get_tree().quit()
#endregion
