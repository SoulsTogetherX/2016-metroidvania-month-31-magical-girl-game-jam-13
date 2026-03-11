class_name RoomManager extends SceneControllerManager


#region Signals
signal events_changed
#endregion


#region Constants
const START_ROOM_PATH := "res://src/main/main_game/rooms/room_19/room.tscn"
const START_MUSIC_PATH := "res://assets/music/1. Mushroom Dungeon.ogg"
#endregion


#region External Variables
@export_group("Internal")
@export var player : Player
@export var camera : GlobalCamera
#endregion


#region Private Variables
var _current_path : String
var _current_music : BackgroundLoader.Task

var _checkpoint : PlayerPositionResource
var _fail_back : PlayerPositionResource
var _gateways : Array[Gateway]

var _events : Dictionary[StringName, bool]

var phan_cam : PhantomCamera2D
var current_room : Node2D
#endregion



#region Virtual Methods
func _init() -> void:
	phan_cam = PhantomCamera2D.new()
	
	phan_cam.follow_mode = PhantomCamera2D.FollowMode.GLUED
	phan_cam.zoom = Vector2.ONE * 0.3
	phan_cam.tween_duration = 0.0
	phan_cam.inactive_update_mode = PhantomCamera2D.InactiveUpdateMode.NEVER
	
	add_child(phan_cam)
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
	_play_music(START_MUSIC_PATH)
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

func _get_gateway(to_id : int) -> Gateway:
	for gateway : Gateway in _gateways:
		if gateway.id == to_id:
			return gateway
	return null
func _get_gateway_pos(gateway : Gateway) -> PlayerPositionResource:
	if gateway:
		return gateway.info
	return _fail_back

func _start_transition(path : String, duration : float = 0.2) -> void:
	Global.player.set_deferred(
		"process_mode", Node.PROCESS_MODE_DISABLED
	)
	await fade_cover(duration)
	CameraZoneManager.focus_camera(phan_cam)
	_fail_back = null
	_gateways.clear()
	
	_current_path = path
	Global.player.global_position = Vector2(
		99999999999, 99999999999
	)
	
	current_room = await scene_controller.change_scene_to_path(
		path, SceneController.UNMOUNT_TYPE.DELETE,
		true
	)
	await current_room.ready
	_update_room_cache()
func _end_transition(duration : float = 0.2) -> void:
	player.force_current_offset()
	phan_cam.follow_target = player
	phan_cam.limit_target = phan_cam.get_path_to(
		current_room.get_node("Collision")
	)
	
	Global.player.process_mode = Node.PROCESS_MODE_INHERIT
	await unfade_cover(duration)

func _play_music(music_path : String) -> void:
	if music_path.is_empty():
		return
	if _current_music && music_path == _current_music.get_resource_path():
		return
	_current_music = BackgroundLoader.request_resource(
		music_path, "AudioStream", get_tree().process_frame
	)
	_current_music.finished.connect(_play_music_helper)

func _play_music_helper() -> void:
	SoundManager.swap_music(
		_current_music.get_resource(),
		1.0, 0.0, 4.0
	)
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
	var gateway := _get_gateway(to_id)
	
	if gateway:
		_play_music(gateway.music_path)
	
	_set_player_position(_get_gateway_pos(gateway))
	_end_transition()

func reset_to_checkpoint() -> void:
	Global.player.no_spike_hit = true
	
	await _start_transition(_current_path)
	_set_player_position(_checkpoint)
	
	Global.player.force_velocity(Vector2.ZERO)
	Global.player.no_spike_hit = false
	_end_transition(1.2)

func flag_event(event : StringName) -> void:
	_events.set(event, true)
	events_changed.emit()
func saw_event(event : StringName) -> bool:
	return _events.get(event, false)
#endregion
