extends Node


#region Private Variables
var _fade_transtion : FadeCoverNode
var _registered_infos : Array[GatewayInfo]
#endregion



#region Virtual Methods
func _ready() -> void:
	# Purely for testing purposes
	await get_tree().root.ready
	_fade_transtion = FadeCoverNode.new()
	Global.game_controller.change_ui_scene_to_node(
		_fade_transtion,
		Constants.TRANSTION_ID
	)
	
	# Purely for testing purposes
	Global.game_controller.change_2d_scene_to_node(
		(load("res://src/rooms/test_scenes/test_scene_1.tscn") as PackedScene).instantiate(),
		Constants.ROOM_ID
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
	
	Global.get_current_room().set_deferred(
		"process_mode", Node.PROCESS_MODE_DISABLED
	)
	
	await _fade_transtion.toggle_fade(true)
	CameraZoneManager.request_snap()
	Global.game_controller.change_2d_scene_to_node(
		node, Constants.ROOM_ID,
		GameController.UNMOUNT_TYPE.DELETE
	)
	
	node.ready.connect(
		_connect_gateway.bind(entrance),
		CONNECT_ONE_SHOT
	)
func _connect_gateway(entrance : GatewayInfo) -> void:
	var exit := _get_exit_by_id(entrance.exit_id)
	Global.player.global_position = exit.exit_pos
	_fade_transtion.toggle_fade(false)
#endregion
