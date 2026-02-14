class_name VelocityComponent extends Node


#region Signals 
signal velocity_changed_immediate
signal velocity_changed
#endregion


#region Private Variables 
var _velocity_changed_queue : bool = false

var _velocity : Vector2:
	get = get_velocity,
	set = force_velocity
var _direction : Vector2i
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
	return _velocity
func get_normalized() -> Vector2:
	return _velocity.normalized()

func force_velocity(vec : Vector2) -> void:
	if vec == _velocity:
		return
	_velocity = vec
	
	if _velocity.x != 0.0:
		_direction.x = signi(int(_velocity.x))
	if _velocity.y != 0.0:
		_direction.y = signi(int(_velocity.y))
	
	velocity_changed_immediate.emit()
	_queue_velocity_changed()
func force_velocity_x(val : float) -> void:
	_velocity.x = val
func force_velocity_y(val : float) -> void:
	_velocity.y = val
#endregion


#region Public Methods (Apply Velocity)
func apply_velocity(
	body : CharacterBody2D,
	update : bool = true
) -> void:
	body.velocity = _velocity
	body.move_and_slide()
	
	if update:
		_velocity = body.velocity
#endregion


#region Public Methods (Velocity flat/lerp changes)
func impulse(flat : Vector2) -> void:
	_velocity += flat

func flat_hor_change(flat : float, delta : float = 1.0) -> void:
	_velocity.x += flat * delta
func lerp_hor_change(to : float, weight : float, delta : float = 1.0) -> void:
	_velocity.x = Utilities.dampf(_velocity.x, to, weight, delta)

func flat_ver_change(flat : float, delta : float = 1.0) -> void:
	_velocity.y += flat * delta
func lerp_ver_change(to : float, weight : float, delta : float = 1.0) -> void:
	_velocity.y = Utilities.dampf(_velocity.y, to, weight, delta)
#endregion


#region Public Methods (Velocity clamp)
func min_hor_velocity(min_val : float) -> void:
	_velocity.x = minf(_velocity.x, min_val)
func max_hor_velocity(min_val : float) -> void:
	_velocity.x = maxf(_velocity.x, min_val)

func min_ver_velocity(min_val : float) -> void:
	_velocity.y = minf(_velocity.y, min_val)
func max_ver_velocity(min_val : float) -> void:
	_velocity.y = maxf(_velocity.y, min_val)
#endregion


#region Public Methods (Helper)
func is_stationary() -> bool:
	return _velocity.is_zero_approx()

func attempting_fall() -> bool:
	return _velocity.y > 0
func attempting_rise() -> bool:
	return _velocity.y < 0
func attempting_idle() -> bool:
	return is_zero_approx(_velocity.x)

func get_direction() -> Vector2i:
	return _direction
func move_direction() -> Vector2:
	return _velocity.sign()
func facing_right() -> bool:
	return _velocity.x > 0
#endregion


#region Public Methods (Draw)
func draw_predicted_velocity(actor : Node2D, from : Vector2) -> void:
	actor.draw_line(
		from,
		_velocity,
		Color.GREEN
	)
#endregion
