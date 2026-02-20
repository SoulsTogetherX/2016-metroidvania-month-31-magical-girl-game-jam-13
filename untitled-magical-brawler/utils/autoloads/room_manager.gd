
extends Node


#region Signals
signal on_gateway_exit(gateway : GatewayInfo)
#endregion


#region Signals
const ROOM_ID := &"__room__"
#endregion


#region Private Variables
var _registered_gateways : Dictionary[int, GatewayInfo]
var _current_entrence : GatewayInfo
#endregion



#region Virtual Methods
func _ready() -> void:
	# Purely for testing purposes
	
	await get_tree().root.ready
	Global.game_controller.change_2d_scene_to_node(
		(load("res://src/rooms/test_scenes/test_scene_1.tscn") as PackedScene).instantiate(),
		ROOM_ID
	)
#endregion



#region Public Methods (Register)
func clear_registered() -> void:
	CameraZoneManager.clear_registered()
	_registered_gateways.clear()
func register_gateway(gateway : GatewayInfo) -> void:
	assert(!_registered_gateways.has(
		gateway.from_id),
		"Attempted to register an existing door id"
	)
	_registered_gateways[gateway.from_id] = gateway
	_check_if_exiting_from(gateway)

func _check_if_exiting_from(exit : GatewayInfo) -> void:
	if _current_entrence && _current_entrence.to_id == exit.from_id:
		on_gateway_exit.emit(exit)
#endregion


#region Public Methods (Activate)
func activate_gateway(id : int) -> void:
	assert(
		_registered_gateways.has(id),
		"Attempted entrance into a nonexistent door id"
	)
	var gateway : GatewayInfo = _registered_gateways.get(id)
	assert(
		!gateway.to_path.is_empty(),
		 "Attempted entrance into a nonexistent room path"
	)
	
	var scene : PackedScene = await gateway.get_room()
	var node = scene.instantiate()
	
	clear_registered()
	var old_room : Node2D = Global.game_controller.change_2d_scene_to_node(
		node,
		ROOM_ID,
		GameController.UNMOUNT_TYPE.NONE
	)
	
	old_room.global_position += (
		_current_entrence.exit_pos - gateway.exit_pos
	)
	
	_current_entrence = gateway
#endregion
