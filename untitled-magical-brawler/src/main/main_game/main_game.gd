class_name RoomManager extends SceneControllerManager


#region Constants
const START_ROOM_PATH := "res://src/main/main_game/rooms/room_14/room.tscn"
#endregion


#region External Variables
@export_group("Internal")
@export var player : Player
@export var camera : GlobalCamera
#endregion


#region Private Variables
var _current_path : String

var _checkpoint : PlayerPositionResource
var _fail_back : PlayerPositionResource
var _gateways : Array[Gateway]
#endregion



#region Virtual Methods
func _ready() -> void:
	super()
	_checkpoint = PlayerPositionResource.new()
	
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
		_checkpoint.exit_pos = Vector2.ZERO
		player.global_position = Vector2.ZERO
		return
	
	_checkpoint.exit_pos = player_pos.exit_pos
	player.global_position = player_pos.exit_pos

func _get_gateway_pos(to_id : int) -> PlayerPositionResource:
	for gateway : Gateway in _gateways:
		if gateway.id == to_id:
			return gateway.info
	return _fail_back

func _start_transition(path : String) -> void:
	await fade_cover()
	_fail_back = null
	_gateways.clear()
	
	_current_path = path
	Global.player.set_deferred(
		"process_mode", Node.PROCESS_MODE_DISABLED
	)
	Global.player.global_position = Vector2(
		99999999999, 99999999999
	)
	
	CameraZoneManager.requested_snap = true
	await (await scene_controller.change_scene_to_path(
		path, SceneController.UNMOUNT_TYPE.DELETE,
		true
	)).ready
	_update_room_cache()
func _end_transition() -> void:
	player.force_current_offset()
	Global.player.process_mode = Node.PROCESS_MODE_INHERIT
	await unfade_cover()
#endregion


#region Public Methods
func register_gateway(gateway : Gateway) -> void:
	_gateways.append(gateway)
func register_checkpoint(play_pos : PlayerPositionResource) -> void:
	_checkpoint = play_pos
func register_failback(play_pos : PlayerPositionResource) -> void:
	_fail_back = play_pos


func change_room_to_path(
	path : String, to_id : int
) -> void:
	await _start_transition(path)
	_set_player_position(_get_gateway_pos(to_id))
	_end_transition()

func reset_to_checkpoint() -> void:
	await _start_transition(_current_path)
	_set_player_position(_checkpoint)
	_end_transition()
#endregion
