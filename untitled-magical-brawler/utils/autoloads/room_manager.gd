extends Node


#region Signals
const TRANSTION_ID := &"__transtion__"
const ROOM_ID := &"__room__"
#endregion


#region Private Variables
var _fade_transtion := preload("res://src/UI/fade_cover/fade_cover.tscn")
var _registered_infos : Array[GatewayInfo]
#endregion



#region Virtual Methods
func _ready() -> void:
	# Purely for testing purposes
	
	await get_tree().root.ready
	Global.game_controller.change_2d_scene_to_node(
		(load("res://src/rooms/test_scenes/test_scene_1.tscn") as PackedScene).instantiate(),
		ROOM_ID
	)
	Global.game_controller.change_ui_scene_to_node(
		_fade_transtion.instantiate(),
		TRANSTION_ID
	)
#endregion


#region Public Methods (Register)
func clear_gateways() -> void:
	_registered_infos.clear()
func register_gateway(info : GatewayInfo) -> void:
	_registered_infos.append(info)
#endregion


#region Public Methods (Access Registered)
func _get_entrance_by_id(id : int) -> GatewayInfo:
	for info : GatewayInfo in _registered_infos:
		if info.id == id:
			return info
	return null
func _get_exit_by_id(id : int) -> GatewayInfo:
	for info : GatewayInfo in _registered_infos:
		if info.exit_id == id:
			return info
	return null
#endregion


#region Public Methods (Activate)
func activate_gateway(id : int) -> void:
	var entrance := _get_entrance_by_id(id)
	assert(
		entrance,
		"Attempted entrance into a nonexistent door id"
	)
	assert(
		!entrance.to_path.is_empty(),
		 "Attempted entrance into a nonexistent room path"
	)
	clear_gateways()
	
	var scene : PackedScene = await entrance.get_room()
	var node := scene.instantiate()
	
	CameraZoneManager.request_snap()
	Global.game_controller.change_2d_scene_to_node(
		node, ROOM_ID,
		GameController.UNMOUNT_TYPE.DELETE
	)
	
	node.ready.connect(
		_connect_gateway.bind(entrance),
		CONNECT_ONE_SHOT
	)
func _connect_gateway(entrance : GatewayInfo) -> void:
	var exit := _get_exit_by_id(entrance.exit_id)
	Global.player.global_position = exit.exit_pos
#endregion
