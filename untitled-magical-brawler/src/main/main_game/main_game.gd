class_name RoomManager extends SceneControllerManager


#region Constants
const START_ROOM_PATH := "res://src/main/main_game/rooms/test_scenes/test_scene_1.tscn"
#endregion


#region External Variables
@export_group("Internal")
@export var player : Player
@export var camera : GlobalCamera
#endregion


#region Private Variables
var _fail_back : PlayerPositionResource
var _gateways : Array[Gateway]
#endregion



#region Virtual Methods
func _ready() -> void:
	super()
	Global.player = player
	Global.camera = camera
	_on_ready_load()
#endregion


#region Private Methods
func _on_ready_load() -> void:
	change_room_to_path(
		START_ROOM_PATH, -1
	)
func _update_room_cache() -> void:
	scene_controller.clear_cache()
	for gateway : Gateway in _gateways:
		scene_controller.background_load_path(
			gateway.exit_path
		)

func _set_player_position(player_pos : PlayerPositionResource) -> void:
	if player_pos == null:
		player.global_position = Vector2.ZERO
		return
	
	player.global_position = player_pos.exit_pos
	player.change_direction(player_pos.face_left)
#endregion


#region Public Methods
func register_gateway(gateway : Gateway) -> void:
	_gateways.append(gateway)
func register_failback(play_pos : PlayerPositionResource) -> void:
	_fail_back = play_pos


func change_room_to_path(
	path : String, to_id : int
) -> void:
	await fade_cover()
	_fail_back = null
	_gateways.clear()
	
	await (await scene_controller.change_scene_to_path(
		path, SceneController.UNMOUNT_TYPE.DELETE,
		true
	)).ready
	
	CameraZoneManager.request_snap()
	_update_room_cache()
	
	var found_gateway : bool = false
	for gateway : Gateway in _gateways:
		if gateway.id == to_id:
			_set_player_position(gateway.info)
			found_gateway = true
			break
	if !found_gateway:
		_set_player_position(_fail_back)
	
	await unfade_cover()
	return


func change_scene_to_failsafe(_path : String) -> void:
	pass
func reset_scene_to_failsafe() -> void:
	pass
#endregion
