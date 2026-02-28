@tool
@abstract
class_name BaseEntity extends CharacterBody2D


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
#endregion


#region Private Export Variables
@export_group("Hidden Exports")
@export var _visual_pivot: Node2D
@export var _velocity_module: VelocityComponent
@export var _task_manager: TaskManager
@export var _animation_player: AnimationPlayer
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
	if property.name in [&"_visual_pivot", &"_velocity_module", &"_task_manager", &"_animation_player"]:
		if owner != null:
			property.usage &= ~PROPERTY_USAGE_EDITOR
#endregion


#region Private Methods (Notifcation Helper)
func _on_ready_notification() -> void:
	_refresh_debugs()
	if Engine.is_editor_hint():
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
func _refresh_velocity_display() -> void:
	if !is_node_ready() || !_velocity_module:
		return
	
	if display_velocity:
		if !draw.is_connected(_draw_trajectory):
			draw.connect(_draw_trajectory)
		if !_velocity_module.velocity_changed.is_connected(queue_redraw):
			_velocity_module.velocity_changed.connect(queue_redraw)
		return
	
	if draw.is_connected(_draw_trajectory):
		draw.disconnect(_draw_trajectory)
	if _velocity_module.velocity_changed.is_connected(queue_redraw):
		_velocity_module.velocity_changed.disconnect(queue_redraw)
#endregion


#region Private Methods (Debug Helper)
func _draw_trajectory() -> void:
	draw_line(
		Vector2.ZERO,
		_velocity_module.get_velocity(),
		Color.GREEN
	)
#endregion


#region Private Methods (Helper)
func _snap_to_ground() -> void:
	var result := Utilities.raycast_manual(
		self, SNAP_RAYCAST_LENGTH,
		Constants.COLLISION.GROUND
	)
	
	_draw_snap_line = result.get(&"collider", null) == null
	if !_draw_snap_line:
		global_position.y = result.position.y
	queue_redraw()
#endregion


#region Public Methods (Helper)
func change_direction(h_flip : bool, v_flip : bool) -> void:
	if !_visual_pivot:
		return
	
	_visual_pivot.scale = Vector2(
		-1.0 if h_flip else 1.0,
		-1.0 if v_flip else 1.0
	)
#endregion


#region Public Methods (Checks)
func has_velocity() -> bool:
	return _velocity_module != null
#endregion


#region Public Methods (Velocity)
func get_velocity_component() -> VelocityComponent:
	return _velocity_module

func get_entity_velocity() -> Vector2:
	if !_velocity_module:
		return Vector2.ZERO
	
	return _velocity_module.get_velocity()
func predict_next_position(delta : float = 1.0) -> Vector2:
	if !_velocity_module:
		return Vector2.ZERO
	
	return global_position + _velocity_module.get_velocity() * delta
#endregion


#region Public Methods
func play_animation(animation_name : StringName) -> void:
	_animation_player.play(animation_name)
func is_animation_playing() -> bool:
	return _animation_player.is_playing()
func get_animation_player() -> AnimationPlayer:
	return _animation_player

func start_task(
	node : TaskNode, args : Dictionary = {},
	overwrite : bool = true
) -> void:
	_task_manager.task_begin(node, args, overwrite)
func end_task(node : TaskNode) -> void:
	_task_manager.task_end(node)
#endregion
