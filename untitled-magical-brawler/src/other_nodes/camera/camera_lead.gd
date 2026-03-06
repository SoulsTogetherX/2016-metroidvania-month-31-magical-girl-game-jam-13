class_name CameraLead extends Marker2D


#region External Variables
@export_group("Settings")
@export var follow : Node2D

@export_group("Positioning")
@export_subgroup("Y Pos")
@export var y_pos : float

@export_subgroup("Direct")
@export var flat_y_offset : float = Constants.DEFAULT_FLAT_Y_OFFSET
@export var direction : Vector2

@export_group("Settings")
@export var x_bias : float = Constants.DEFAULT_X_BAIS
@export var y_bias : float = Constants.DEFAULT_Y_BAIS
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
func _update_y_tween(duration := 1.5) -> void:
	if _y_tween:
		_y_tween.kill()
	
	_y_tween = create_tween()
	_y_tween.set_ease(Tween.EASE_OUT)
	_y_tween.set_trans(Tween.TRANS_SINE)
	_y_tween.tween_property(
		self,
		"_current_offset:y",
		y_pos + direction.y * y_bias,
		duration
	)
func _update_x_tween(duration := 2.0) -> void:
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
		duration
	)
#endregion


#region Public Methods (Helper)
func force_current_offset() -> void:
	if _x_tween:
		_x_tween.kill()
	if _y_tween:
		_y_tween.kill()
	
	_current_offset.x = 0.0
	_current_offset.y = (direction.y * y_bias) + y_pos

func set_x_bias(val : float) -> void:
	x_bias = val
	_update_x_tween()
func set_y_bias(val : float) -> void:
	y_bias = val
	_update_y_tween()
func set_flat_y_offset(val : float) -> void:
	flat_y_offset = val
	_update_y_tween()


func set_y_pos(val : float) -> void:
	y_pos = val
	_update_y_tween()

func set_direction(val : Vector2) -> void:
	direction = val
	_update_y_tween()
	_update_x_tween()
func update_direction() -> void:
	_update_y_tween()
	_update_x_tween()
#endregion
