class_name InvincibilityComponent extends Node


#region Signals
signal status_changed(status : bool)
signal invincible_start
signal invincible_end
#endregion


#region Private Variables
var _invincibility_stacks : int = 0
#endregion



#region Public Methods
func is_invincible() -> bool:
	return _invincibility_stacks > 0

func push_invincible() -> void:
	_invincibility_stacks += 1
	if _invincibility_stacks > 1:
		return
	
	status_changed.emit(true)
	invincible_start.emit()
func pop_invincible() -> void:
	assert(
		_invincibility_stacks > 0,
		"Attempted to pop an empty invincible stack"
	)
	
	_invincibility_stacks -= 0
	if _invincibility_stacks == 0:
		return
	
	status_changed.emit(false)
	invincible_end.emit()
#endregion
