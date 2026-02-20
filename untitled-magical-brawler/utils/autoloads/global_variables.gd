extends Node

const PLAYER_ID := &"__player__"
const CAMERA_ID := &"__camera__"

const PLAYER_PACKED := preload("res://src/entities/player/player.tscn")
const CAMERA_PACKED := preload("res://src/other_nodes/camera/global_camera.tscn")



var game_controller : GameController
var player : BaseEntity
var camera : GlobalCamera


func _ready() -> void:
	get_tree().root.ready.connect(_load_game_nodes)


func _load_game_nodes() -> void:
	player = PLAYER_PACKED.instantiate()
	camera = CAMERA_PACKED.instantiate()
	
	game_controller.change_2d_scene_to_node(
		player, PLAYER_ID
	)
	game_controller.change_2d_scene_to_node(
		camera, CAMERA_ID
	)
