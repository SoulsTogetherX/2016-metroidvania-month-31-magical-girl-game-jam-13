extends Node


#region Constants
const PLAYER_PACKED := preload("res://src/entities/player/player.tscn")
const CAMERA_PACKED := preload("res://src/other_nodes/camera/global_camera.tscn")
#endregion


#region Public Variables
var game_controller : GameController
var player : BaseEntity
var camera : GlobalCamera
#endregion



#region Virtual Methods
func _ready() -> void:
	get_tree().root.ready.connect(_load_game_nodes)
#endregion


#region Private Methods (Temp)
func _load_game_nodes() -> void:
	# Purely for testing
	player = PLAYER_PACKED.instantiate()
	camera = CAMERA_PACKED.instantiate()
	
	game_controller.change_2d_scene_to_node(
		player, Constants.PLAYER_ID
	)
	game_controller.change_2d_scene_to_node(
		camera, Constants.CAMERA_ID
	)
#endregion


#region Public Methods (Helper)
func get_current_room() -> Node2D:
	return game_controller.get_node_2d_from_id(Constants.ROOM_ID)
#endregion
