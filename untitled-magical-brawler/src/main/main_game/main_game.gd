class_name RoomManager extends SceneControllerManager


#region Signals
signal events_changed
#endregion


#region Constants
const START_ROOM_PATH := "res://src/main/main_game/rooms/room_1/room.tscn"
#endregion


#region External Variables
@export_group("Internal")
@export var player : Player
@export var camera : GlobalCamera

@export_group("Modules")
@export var environment_controller : WorldEnvironment
@export var background_controller : SceneController

@export var ability_ui : AbilityUIDisplay
#endregion


#region Private Variables
var _current_path : String
var _current_music : BackgroundLoader.Task

var _check_point : Vector2
var _failback_point : Vector2
var _gateways : Array[Gateway]

var _events : Dictionary[StringName, bool]

var phan_cam : PhantomCamera2D
var current_room : Room
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
	
	Global.player = player
	Global.camera = camera
	
	add_to_group(
		GlobalLabels.groups.SAVEABLE_GROUP_NAME
	)
	SaveManager.load_file(SaveManager.DEFAULT_FILE_NAME)
#endregion


#region Private Methods
func _update_room_cache() -> void:
	scene_controller.clear_cache()
	for gateway : Gateway in _gateways:
		scene_controller.background_load_path(
			gateway.exit_path
		)

func _set_player_position(exit_pos : Vector2) -> void:
	player.global_position = exit_pos

func _get_gateway(to_id : int) -> Gateway:
	for gateway : Gateway in _gateways:
		if gateway.id == to_id:
			return gateway
	return null
func _get_gateway_pos(gateway : Gateway) -> Vector2:
	if gateway:
		return gateway.global_position
	return _failback_point

func _start_transition(path : String, duration : float = 0.2) -> void:
	Global.player.set_deferred(
		"process_mode", Node.PROCESS_MODE_DISABLED
	)
	await fade_cover(duration)
	CameraZoneManager.focus_camera(phan_cam)
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


func _play_music_helper() -> void:
	SoundManager.swap_music(
		_current_music.get_resource(),
		1.0, 0.0, 4.0
	)
func _fade_out(time : float = 1.0) -> void:
	SoundManager.swap_music(
		null, 1.0, 0.0, time
	)
#endregion


#region Private Methods (Save/Load)
func _request_save() -> void:
	SaveManager.set_key(
		SaveManager.SAVE_KEYS.EVENTS,
		_events
	)
	SaveManager.set_key(
		SaveManager.SAVE_KEYS.ROOM,
		_current_path
	)
	SaveManager.set_key(
		SaveManager.SAVE_KEYS.POSITION,
		_check_point
	)
func _request_load() -> void:
	var events = SaveManager.get_key(
		SaveManager.SAVE_KEYS.EVENTS
	)
	var room_path = SaveManager.get_key(
		SaveManager.SAVE_KEYS.ROOM
	)
	var pos = SaveManager.get_key(
		SaveManager.SAVE_KEYS.POSITION
	)
	
	if events != null:
		_events = events
	if pos != null:
		_check_point = pos
	if room_path == null:
		room_path = START_ROOM_PATH
	
	change_room_to_path(room_path, -1 if pos != null else -2)
#endregion


#region Public Methods
func register_gateway(gateway : Gateway) -> void:
	_gateways.append(gateway)
func register_fail_back(exit_pos : Vector2) -> void:
	_failback_point = exit_pos
func register_checkpoint(exit_pos : Vector2) -> void:
	_check_point = exit_pos


func change_room_to_path(
	path : String, to_id : int
) -> void:
	await _start_transition(path)
	
	var gateway : Gateway
	if to_id != -1:
		gateway = _get_gateway(to_id)
	
	await change_background(current_room.background)
	environment_controller.environment = current_room.env
	
	if !gateway || !gateway.pause_music:
		play_music(current_room.music)
	else:
		clear_music()
	
	var pos : Vector2 
	if to_id != -1:
		pos = _get_gateway_pos(gateway)
		_check_point = pos
	else:
		pos = _check_point
	
	_set_player_position(pos)
	_end_transition()

func reset_to_checkpoint() -> void:
	Global.player.no_spike_hit = true
	
	await _start_transition(_current_path)
	_set_player_position(_check_point)
	
	Global.player.force_velocity(Vector2.ZERO)
	Global.player.no_spike_hit = false
	_end_transition(1.2)

func flag_event(event : StringName) -> void:
	_events.set(event, true)
	events_changed.emit()
func saw_event(event : StringName) -> bool:
	return _events.get(event, false)

func display_ability(ability : AbilityData) -> void:
	ability_ui.display_ability(ability)


func change_background(background_path : String) -> void:
	await background_controller.change_scene_to_path(
		background_path, SceneController.UNMOUNT_TYPE.REMOVE
	)

func clear_music() -> void:
	SoundManager.swap_music(
		null, 1.0, 0.0, 1.0
	)
func play_music(music_path : String) -> void:
	if music_path.is_empty():
		_fade_out()
		
		if _current_music && _current_music.finished.is_connected(_play_music_helper):
			_current_music.finished.disconnect(_play_music_helper)
		_current_music = null
		return
	if _current_music && music_path == _current_music.get_resource_path():
		return
	_current_music = BackgroundLoader.request_resource(
		music_path, "AudioStream", get_tree().process_frame
	)
	_current_music.finished.connect(_play_music_helper)
#endregion
