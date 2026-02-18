@tool
class_name VelocityComponent extends Node


#region Signals 
signal velocity_changed_immediate
signal velocity_changed

signal direction_changed
signal horizontal_direction_changed
signal vertical_direction_changed
#endregion


#region Public Variables
var velocity : Vector2:
	get = get_velocity,
	set = set_velocity
#endregion


#region Private Variables 
var _velocity_changed_queue : bool = false
var _direction : Vector2i:
	set(val):
		if val == _direction:
			return
		var old_direction := _direction
		_direction = val
		
		direction_changed.emit()
		if val.x != old_direction.x:
			horizontal_direction_changed.emit()
		if val.y != old_direction.y:
			vertical_direction_changed.emit()
#endregion


#region Private Methods (Queue)
func _queue_velocity_changed() -> void:
	if _velocity_changed_queue:
		return
	_velocity_changed_queue = true
	
	call_deferred(&"_emit_velocity_changed")
func _emit_velocity_changed() -> void:
	_velocity_changed_queue = false
	velocity_changed.emit()
#endregion


#region Public Methods (Helper)
func get_velocity() -> Vector2:
	return velocity
func get_normalized() -> Vector2:
	return velocity.normalized()

func set_velocity(vec : Vector2) -> void:
	if vec == velocity:
		return
	velocity = vec
	
	if !velocity.is_zero_approx():
		_direction = velocity.sign()
	
	velocity_changed_immediate.emit()
	_queue_velocity_changed()
#endregion


#region Public Methods (Apply Velocity)
func apply_velocity(
	body : CharacterBody2D,
	update : bool = true
) -> void:
	if !body:
		return
	
	body.velocity = velocity
	body.move_and_slide()
	
	if update:
		velocity = body.velocity
#endregion


#region Public Methods (Velocity flat/lerp changes)
func flat_change(flat : Vector2, delta : float) -> void:
	velocity += flat * delta
func lerp_change(to : Vector2, weight : Vector2, delta : float) -> void:
	velocity = Utilities.dampv(velocity, to, weight, delta)
func flat_changef(flat : float, delta : float) -> void:
	velocity += Vector2(flat, flat) * delta
func lerp_changef(to : Vector2, weight : float, delta : float) -> void:
	velocity = Vector2(
		Utilities.dampf(velocity.x, to.x, weight, delta),
		Utilities.dampf(velocity.y, to.y, weight, delta)
	)

func flat_hor_change(flat : float, delta : float) -> void:
	velocity.x += flat * delta
func lerp_hor_change(to : float, weight : float, delta : float) -> void:
	velocity.x = Utilities.dampf(velocity.x, to, weight, delta)

func flat_ver_change(flat : float, delta : float) -> void:
	velocity.y += flat * delta
func lerp_ver_change(to : float, weight : float, delta : float) -> void:
	velocity.y = Utilities.dampf(velocity.y, to, weight, delta)
#endregion


#region Public Methods (Velocity clamp)
func min_velocity(min_val : Vector2) -> void:
	velocity = velocity.min(min_val)
func max_velocity(max_val : Vector2) -> void:
	velocity = velocity.max(max_val)
func min_velocityf(min_val : float) -> void:
	velocity = velocity.minf(min_val)
func max_velocityf(max_val : float) -> void:
	velocity = velocity.maxf(max_val)

func min_hor_velocity(min_val : float) -> void:
	velocity.x = minf(velocity.x, min_val)
func max_hor_velocity(min_val : float) -> void:
	velocity.x = maxf(velocity.x, min_val)

func min_ver_velocity(min_val : float) -> void:
	velocity.y = minf(velocity.y, min_val)
func max_ver_velocity(min_val : float) -> void:
	velocity.y = maxf(velocity.y, min_val)
#endregion


#region Public Methods (Helper)
func is_stationary() -> bool:
	return velocity.is_zero_approx()

func attempting_fall() -> bool:
	return velocity.y > 0
func attempting_rise() -> bool:
	return velocity.y < 0
func attempting_idle() -> bool:
	return is_zero_approx(velocity.x)

func get_direction() -> Vector2i:
	return _direction
func get_hor_direction() -> int:
	return _direction.x
func get_ver_direction() -> int:
	return _direction.y

func facing_left() -> bool:
	return _direction.x < 0
func facing_up() -> bool:
	return _direction.y < 0
#endregion


#region Public Methods (Draw)
func draw_predicted_velocity(actor : Node2D, from : Vector2) -> void:
	actor.draw_line(
		from,
		velocity,
		Color.GREEN
	)
#endregion
