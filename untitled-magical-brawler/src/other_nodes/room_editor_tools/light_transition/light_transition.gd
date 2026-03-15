extends Area2D


#region External Variables
@export var env : Environment

@export var expected : float = 1.1
@export var instant : bool = false
#endregion


#region Private Variables
var _tween : Tween
#endregion



#region Virtual Methods
func _init() -> void:
	collision_mask = Constants.COLLISION.PLAYER
	collision_layer = 0
	monitoring = true
	monitorable = false
	
	body_entered.connect(_player_detects.unbind(1))
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			if _tween:
				_tween.kill()
			env.adjustment_brightness = expected
#endregion


#region Private Methods
func _player_detects() -> void:
	if _tween:
		return
	
	if instant:
		env.adjustment_brightness = expected
		return
	
	_tween = create_tween()
	_tween.set_ease(Tween.EASE_IN_OUT)
	_tween.set_trans(Tween.TRANS_SINE)
	_tween.tween_property(
		env, "adjustment_brightness",
		expected, 2.0
	)
#endregion
