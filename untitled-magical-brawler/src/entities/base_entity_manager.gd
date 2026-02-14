@tool
class_name BaseEntityManager extends Node2D


#region Constant
var SNAP_RAYCAST_LENGTH := 500 
#endregion


#region Export Variables
@export_group("Debug")
@export_tool_button("Snap To Ground") var snap_func = _snap_to_ground 
@export var display_velocity : bool = false:
	set(val):
		if val == display_velocity:
			return
		display_velocity = val
		_refresh_display_velocity()
#endregion


#region Private Export Variables
@export_group("Hidden Exports")
@export var _actor: Node2D
@export var _velocity: VelocityComponent
#endregion


#region Private Variables
var _draw_snap_line : bool
#endregion



#region Virtual Methods
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_READY:
			_on_ready_notification()
		NOTIFICATION_DRAW:
			_on_draw_notification()

func _validate_property(property: Dictionary) -> void:
	if property.name in [&"_actor", &"_velocity"]:
		if owner != null:
			property.usage &= ~PROPERTY_USAGE_EDITOR
#endregion


#region Private Methods (Notifcation Helper)
func _on_ready_notification() -> void:
	if !_actor:
		push_error("Error - No actor found in 'BaseEntityManager'")
		return
	if Engine.is_editor_hint():
		return
	_refresh_debugs()

func _on_draw_notification() -> void:
	if !Engine.is_editor_hint():
		return
	if _draw_snap_line:
		_draw_snap_line = false
		draw_line(Vector2.ZERO, Vector2(0, SNAP_RAYCAST_LENGTH), Color.RED)
#endregion


#region Private Methods (Toggle)
func _refresh_debugs() -> void:
	_refresh_display_velocity()
func _refresh_display_velocity() -> void:
	if !is_node_ready() || !_velocity:
		return
	
	if display_velocity:
		if !_actor.draw.is_connected(_draw_trajectory):
			_actor.draw.connect(_draw_trajectory)
		if !_velocity.velocity_changed.is_connected(_actor.queue_redraw):
			_velocity.velocity_changed.connect(_actor.queue_redraw)
		return
	
	if _actor.draw.is_connected(_draw_trajectory):
		_actor.draw.disconnect(_draw_trajectory)
	if _velocity.velocity_changed.is_connected(_actor.queue_redraw):
		_velocity.velocity_changed.disconnect(_actor.queue_redraw)
#endregion


#region Private Methods (Debug Helper)
func _draw_trajectory() -> void:
	_actor.draw_line(
		Vector2.ZERO,
		_velocity.get_velocity(),
		Color.GREEN
	)
#endregion


#region Private Methods (Helper)
func _snap_to_ground() -> void:
	var space_state := get_world_2d().direct_space_state
	var origin := global_position
	var end := global_position + Vector2(0, SNAP_RAYCAST_LENGTH)
	
	var query := PhysicsRayQueryParameters2D.create(origin, end)
	query.collision_mask = Constants.LAYERS.GROUND
	var result := space_state.intersect_ray(query)
	
	_draw_snap_line = result.get(&"collider", null) == null
	if !_draw_snap_line:
		global_position.y = result.position.y
	queue_redraw()
#endregion


#region Public Methods (Checks)
func has_velocity() -> bool:
	return _velocity != null
#endregion


#region Public Methods (Velocity)
func get_positon() -> Vector2:
	return _actor.global_position
func get_local_position() -> Vector2:
	return _actor.position
#endregion


#region Public Methods (Velocity)
func get_velocity() -> Vector2:
	if !_velocity:
		return Vector2.ZERO
	
	return _velocity.get_velocity()
func predict_next_position(delta : float = 1.0) -> Vector2:
	if !_velocity:
		return Vector2.ZERO
	
	return _actor.global_position + _velocity.get_velocity() * delta
#endregion
