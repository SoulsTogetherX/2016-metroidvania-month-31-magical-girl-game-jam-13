class_name CameraLead extends Marker2D


#region External Variables
@export_group("Settings")
@export var follow : Node2D

@export_group("Positioning")
@export var y_pos : float:
	set = set_y_pos
@export var flat_y_offset : float = -960.0:
	set = set_flat_y_offset
@export var direction : Vector2:
	set = set_direction

@export_group("Settings")
@export var x_bias : float = 700:
	set = set_x_bias
@export var y_bias : float = 700:
	set = set_y_bias
#endregion


#region Private Variables
var _y_tween : Tween
var _x_tween : Tween

var _current_offset : Vector2
#endregion



#region Virtual Methods
func _physics_process(_delta: float) -> void:
	global_position = Vector2(
		follow.global_position.x,
		flat_y_offset
	) + _current_offset
#endregion


#region Private Methods
func _update_y_tween() -> void:
	if _y_tween:
		_y_tween.kill()
	
	_y_tween = create_tween()
	_y_tween.set_ease(Tween.EASE_OUT)
	_y_tween.set_trans(Tween.TRANS_SINE)
	_y_tween.tween_property(
		self,
		"_current_offset:y",
		y_pos + direction.y * y_bias,
		1.5
	)
func _update_x_tween() -> void:
	if is_zero_approx(direction.x):
		return
	if _x_tween:
		_x_tween.kill()
	
	_x_tween = create_tween()
	_y_tween.set_ease(Tween.EASE_OUT)
	_y_tween.set_trans(Tween.TRANS_CIRC)
	_x_tween.tween_property(
		self,
		"_current_offset:x",
		direction.x * x_bias,
		2
	)
#endregion


#region Public Methods (Helper)
func force_current_offset() -> void:
	if _x_tween:
		_x_tween.kill()
	if _y_tween:
		_y_tween.kill()
	_current_offset = direction * Vector2(
		x_bias, y_bias
	) + Vector2(0, y_pos)

func set_x_bias(val : float) -> void:
	if val == x_bias:
		return
	x_bias = val
	_update_x_tween()
func set_y_bias(val : float) -> void:
	if val == y_bias:
		return
	y_bias = val
	_update_y_tween()
func set_flat_y_offset(val : float) -> void:
	if val == flat_y_offset:
		return
	flat_y_offset = val
	_update_y_tween()


func set_y_pos(val : float) -> void:
	if val == y_pos:
		return
	y_pos = val
	_update_y_tween()
func set_direction(val : Vector2) -> void:
	if val == direction:
		return
	direction = val
	_update_y_tween()
	_update_x_tween()
#endregion
