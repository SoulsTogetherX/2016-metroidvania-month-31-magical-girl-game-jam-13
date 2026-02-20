extends Node


#region Private Variables
var _registered_infos : Array[GatewayInfo]
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
	
	var scene : PackedScene = await entrance.get_room()
	var room := scene.instantiate()
	
	await _pre_room_switch()
	_room_switch(room)
	room.ready.connect(
		_post_room_switch.bind(entrance),
		CONNECT_ONE_SHOT
	)

func _pre_room_switch() -> void:
	clear_gateways()
	
	Global.get_current_room().set_deferred(
		"process_mode", Node.PROCESS_MODE_DISABLED
	)
	Global.player.set_deferred(
		"process_mode", Node.PROCESS_MODE_DISABLED
	)
	
	await Global.game_controller.get_ui_from_id(
		Constants.TRANSTION_ID
	).toggle_fade(true)
func _room_switch(room : Node2D) -> void:
	CameraZoneManager.request_snap()
	Global.game_controller.change_2d_scene_to_node(
		room, Constants.ROOM_ID,
		GameController.UNMOUNT_TYPE.DELETE
	)
func _post_room_switch(entrance : GatewayInfo) -> void:
	var exit := _get_exit_by_id(entrance.exit_id)
	
	Global.player.global_position = exit.exit_pos
	Global.player.process_mode = Node.PROCESS_MODE_INHERIT
	await Global.game_controller.get_ui_from_id(
		Constants.TRANSTION_ID
	).toggle_fade(false)
#endregion
