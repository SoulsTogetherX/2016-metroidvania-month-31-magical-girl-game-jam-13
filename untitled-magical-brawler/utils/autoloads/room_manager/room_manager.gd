
extends Node


#region Signals
signal on_gateway_exit(gateway : GatewayInfo)
#endregion


#region Private Variables
var _room_transition : RoomTransitionNode
var _registered : Dictionary[int, GatewayInfo]
#endregion



#region Virtual Methods
func _ready() -> void:
	_room_transition = RoomTransitionNode.new()
	get_tree().root.add_child.call_deferred(_room_transition)
#endregion


#region Private Methods (Signal)
func _on_room_startup(entrance : GatewayInfo) -> void:
	assert(_registered.has(entrance.to_id), "Attempted exit from a nonexistent door id")
	var exit : GatewayInfo = _registered.get(entrance.from_id)
	on_gateway_exit.emit(exit)
#endregion



#region Public Methods (Register)
func clear_registered() -> void:
	CameraZoneManager.clear_registered()
	_registered.clear()
func register_gateway(gateway : GatewayInfo) -> void:
	assert(!_registered.has(gateway.from_id), "Attempted to register an existing door id")
	_registered[gateway.from_id] = gateway
#endregion


#region Public Methods (Activate)
func activate_gateway(id : int) -> void:
	assert(_registered.has(id), "Attempted entrance into a nonexistent door id")
	var gateway : GatewayInfo = _registered.get(id)
	assert(!gateway.to_path.is_empty(), "Attempted entrance into a nonexistent room path")
	
	var scene : PackedScene = await gateway.get_room()
	var node = scene.instantiate()
	
	clear_registered()
	_room_transition.goto_scene(node)
	node.ready.connect(
		_on_room_startup.bind(gateway),
		CONNECT_ONE_SHOT
	)
#endregion
