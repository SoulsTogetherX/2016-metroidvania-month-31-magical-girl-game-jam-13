extends Node


#region Constants
const PLAYER_PACKED := "res://src/entities/combat_entities/player/player.tscn"
const CAMERA_PACKED := "res://src/other_nodes/camera/global_camera.tscn"
#endregion


#region Enums
enum PRESET {
	GAME
}
#endregion



#region Virtual Methods
func _ready() -> void:
	# For testing purposes
	load_preset(PRESET.GAME)
#endregion


#region Load Preset
func load_preset(preset : PRESET, destroy_all : bool = true) -> void:
	if destroy_all:
		var game := Global.game_controller
		game.destroy_all_2d_nodes()
		game.destroy_all_3d_nodes()
		game.destroy_all_ui_nodes()
	
	match preset:
		PRESET.GAME:
			_load_game()
#endregion


#region Game Preset
func _load_game() -> void:
	_load_game_objects()
	_load_game_ui()
	# Hard coded for testing
	_load_game_room("res://src/rooms/test_scenes/test_scene_1.tscn")

func _load_game_objects() -> void:
	var game := Global.game_controller
	
	Global.player = load(PLAYER_PACKED).instantiate()
	Global.camera = load(CAMERA_PACKED).instantiate()
	
	game.change_2d_scene_to_node(
		Global.player, Constants.PLAYER_ID
	)
	
	# Stress-Testing performance
	#for i : int in range(100):
	#	game.change_2d_scene_to_node(
	#		load(PLAYER_PACKED).instantiate(), Constants.PLAYER_ID + str(i)
	#	)
	game.change_2d_scene_to_node(
		Global.camera, Constants.CAMERA_ID
	)

func _load_game_ui() -> void:
	var game := Global.game_controller
	
	game.change_ui_scene_to_node(
		FadeCoverNode.new(),
		Constants.TRANSTION_ID
	)

func _load_game_room(room_path : String) -> void:
	var game := Global.game_controller
	
	game.change_2d_scene_to_node(
		(load(room_path) as PackedScene).instantiate(),
		Constants.ROOM_ID
	)
#endregion
