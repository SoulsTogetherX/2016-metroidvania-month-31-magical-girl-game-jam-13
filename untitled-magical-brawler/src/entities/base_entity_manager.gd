@tool
class_name BaseEntityManager extends Node2D


#region Constant
var SNAP_RAYCAST_LENGTH := 500 
#endregion


#region Export Variables
@export_group("Debug")
@export_tool_button("Snap To Ground") var snap_func = _snap_to_ground 

@export_subgroup("Velocity")
@export var display_velocity : bool = false:
	set(val):
		if val == display_velocity:
			return
		display_velocity = val
		
		_refresh_velocity_display()

@export_subgroup("Health")
@export var display_health : bool = false:
	set(val):
		if val == display_health:
			return
		display_health = val
		
		_refresh_health_display()
@export var display_health_offset : Vector2:
	set(val):
		if val == display_health_offset:
			return
		display_health_offset = val
		
		if is_node_ready() && _health_display:
			_health_display.follow_offset = display_health_offset
#endregion


#region Private Export Variables
@export_group("Hidden Exports")
@export var _actor: Node2D
@export var _velocity_m: VelocityComponent
@export var _health_m: HealthComponent
#endregion


#region Private Variables
var _health_display : DebugHealthDisplayLabel
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
	if property.name in [&"_actor", &"_velocity_m", &"_health_m"]:
		if owner != null:
			property.usage &= ~PROPERTY_USAGE_EDITOR
#endregion


#region Private Methods (Notifcation Helper)
func _on_ready_notification() -> void:
	_refresh_debugs()
	if Engine.is_editor_hint():
		return
	if !_actor:
		push_error("Error - No actor found in 'BaseEntityManager'")
		return

func _on_draw_notification() -> void:
	if !Engine.is_editor_hint():
		return
	if _draw_snap_line:
		_draw_snap_line = false
		draw_line(Vector2.ZERO, Vector2(0, SNAP_RAYCAST_LENGTH), Color.RED)
#endregion


#region Private Methods (Toggle)
func _refresh_debugs() -> void:
	_refresh_velocity_display()
	_refresh_health_display()
func _refresh_velocity_display() -> void:
	if !is_node_ready() || !_velocity_m:
		return
	
	if display_velocity:
		if !_actor.draw.is_connected(_draw_trajectory):
			_actor.draw.connect(_draw_trajectory)
		if !_velocity_m.velocity_changed.is_connected(_actor.queue_redraw):
			_velocity_m.velocity_changed.connect(_actor.queue_redraw)
		return
	
	if _actor.draw.is_connected(_draw_trajectory):
		_actor.draw.disconnect(_draw_trajectory)
	if _velocity_m.velocity_changed.is_connected(_actor.queue_redraw):
		_velocity_m.velocity_changed.disconnect(_actor.queue_redraw)
func _refresh_health_display() -> void:
	if !is_node_ready():
		return
	
	if display_health:
		if !_health_display:
			_health_display = DebugHealthDisplayLabel.new()
			add_child(_health_display)
		
		_health_display.health_m = _health_m
		_health_display.follow = self
		_health_display.follow_offset = display_health_offset
		return
	
	if _health_display:
		_health_display.queue_free()
		_health_display = null
#endregion


#region Private Methods (Debug Helper)
func _draw_trajectory() -> void:
	_actor.draw_line(
		Vector2.ZERO,
		_velocity_m.get_velocity(),
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
	return _velocity_m != null
func has_health() -> bool:
	return _health_m != null
#endregion


#region Public Methods (Velocity)
func get_positon() -> Vector2:
	return _actor.global_position
func get_local_position() -> Vector2:
	return _actor.position
#endregion


#region Public Methods (Velocity)
func get_velocity_compoenent() -> VelocityComponent:
	return _velocity_m

func get_velocity() -> Vector2:
	if !_velocity_m:
		return Vector2.ZERO
	
	return _velocity_m.get_velocity()
func predict_next_position(delta : float = 1.0) -> Vector2:
	if !_velocity_m:
		return Vector2.ZERO
	
	return _actor.global_position + _velocity_m.get_velocity() * delta
#endregion


#region Public Methods (Health)
func get_health_compoenent() -> HealthComponent:
	return _health_m

func get_health() -> int:
	if !_health_m:
		return 0
	return _health_m.get_health()
func get_max_health() -> int:
	if !_health_m:
		return 0
	return _health_m.get_max_health()
#endregion
