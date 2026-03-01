class_name CameraLead extends Marker2D


#region Constants
const CAMERA_LEAD_Y_OFFSET := -960.0
#endregion


#region External Variables
@export var follow : Node2D
@export var y_pos : float:
	set = set_y_pos
@export var offset : Vector2:
	set = set_offset
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
		CAMERA_LEAD_Y_OFFSET
	) + _current_offset
#endregion


#region Private Methods
func update_y_tween() -> void:
	if _y_tween:
		_y_tween.kill()
	
	_y_tween = create_tween()
	_y_tween.set_ease(Tween.EASE_OUT)
	_y_tween.set_trans(Tween.TRANS_CIRC)
	_y_tween.tween_property(
		self,
		"_current_offset:y",
		y_pos + offset.y,
		0.6
	)
func update_x_tween() -> void:
	if is_zero_approx(offset.x):
		return
	if _x_tween:
		_x_tween.kill()
	
	_x_tween = create_tween()
	_y_tween.set_ease(Tween.EASE_OUT)
	_y_tween.set_trans(Tween.TRANS_CIRC)
	_x_tween.tween_property(
		self,
		"_current_offset:x",
		offset.x,
		2
	)
#endregion


#region Public Methods (Helper)
func set_y_pos(val : float) -> void:
	if val == y_pos:
		return
	y_pos = val
	update_y_tween()
func set_offset(val : Vector2) -> void:
	if val == offset:
		return
	offset = val
	update_y_tween()
	update_x_tween()
#endregion
