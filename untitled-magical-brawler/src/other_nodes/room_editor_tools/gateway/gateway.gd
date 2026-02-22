@tool
class_name Gateway extends Area2D


#region Constants
const BASE_COLOR := Color(0.7, 0.5, 1.0, 0.4)
const DEFAULT_SHAPE_SIZE := Vector2(100, 500)
const COLLISION_NAME := "GatewayCollider"
const EXIT_MARKER_NAME := "GatewayExit"
#endregion


#region External Variables
@export var gateway_info : GatewayInfo:
	set(val):
		if val == gateway_info:
			return
		
		if gateway_info:
			gateway_info.destination_changed.disconnect(update_configuration_warnings)
			gateway_info.exit_postion_changed.disconnect(_update_marker_positon)
			gateway_info.direction_changed.disconnect(_update_marker_direction)
		gateway_info = val
		if gateway_info:
			gateway_info.cache_room()
			
			gateway_info.destination_changed.connect(update_configuration_warnings)
			gateway_info.exit_postion_changed.connect(_update_marker_positon)
			gateway_info.direction_changed.connect(_update_marker_direction)
		update_configuration_warnings()
#endregion


#region Private Variables (Confirmed Children)
var _gateway_marker : GatewayExitMarker2D
#endregion



#region Virtual Methods
func _init() -> void:
	monitoring = true
	monitorable = false
	collision_layer = 0
	collision_mask = Constants.COLLISION.PLAYER
func _ready() -> void:
	if !Engine.is_editor_hint():
		RoomManager.register_gateway(gateway_info)
		body_entered.connect(_on_player_enter)
		return
	
	EditorUtilities.confirmed_child(
		self,
		&"",
		COLLISION_NAME,
		_create_collider,
		func(_node): pass,
		0
	)
	EditorUtilities.confirmed_child(
		self,
		&"_gateway_marker",
		EXIT_MARKER_NAME,
		_create_marker,
		func(_node): pass,
		1
	)

func _get_configuration_warnings() -> PackedStringArray:
	if gateway_info == null:
		return ["This gateway has no destination infos 'gateway_info' property is null."]
	if gateway_info.to_path.is_empty():
		return ["This gateway isn't connected to a room."]
	
	return []
#endregion


#region Private Methods (Confirmed Children)
func _create_collider() -> CollisionShape2D:
	var node := CollisionShape2D.new()
	
	node.shape = RectangleShape2D.new()
	node.shape.size = DEFAULT_SHAPE_SIZE
	
	return node

func _create_marker() -> GatewayExitMarker2D:
	var node := GatewayExitMarker2D.new()
	
	node.position_changed.connect(_on_marker_positon_changed, CONNECT_PERSIST)
	node.direction_changed.connect(_on_marker_direction_changed, CONNECT_PERSIST)
	
	return node
#endregion


#region Private Methods (Signal)
func _on_player_enter(body : BaseEntity) -> void:
	assert(gateway_info, "Cannot enter a gateway with no attached exit.")
	assert(body, "Invaild Entity detected in gateway.")
	
	gateway_info.player_offset = body.global_position - gateway_info.exit_pos
	RoomManager.activate_gateway(gateway_info.exit_id)

func _on_marker_positon_changed() -> void:
	if !gateway_info || !_gateway_marker:
		return
	gateway_info.exit_pos = _gateway_marker.global_position
func _update_marker_positon() -> void:
	_gateway_marker.global_position = gateway_info.exit_pos

func _on_marker_direction_changed() -> void:
	if !gateway_info || !_gateway_marker:
		return
	gateway_info.facing_left = _gateway_marker.facing_left
func _update_marker_direction() -> void:
	_gateway_marker.facing_left = gateway_info.facing_left
#endregion
