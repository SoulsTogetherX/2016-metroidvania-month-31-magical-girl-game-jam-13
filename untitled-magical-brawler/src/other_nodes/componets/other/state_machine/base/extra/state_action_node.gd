@abstract
class_name StateActionNode extends StateNode


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent
#endregion



#region Private Methods (Signal)
func _connect_action_cache() -> void:
	if action_cache:
		action_cache.action_started.connect(action_start)
		action_cache.action_finished.connect(action_finished)
func _disconnect_action_cache() -> void:
	if action_cache:
		action_cache.action_started.disconnect(action_start)
		action_cache.action_finished.disconnect(action_finished)
#endregion


#region Private Methods (Helper)
func _enter_state() -> void:
	_connect_action_cache()
	super()
func _exit_state() -> void:
	_disconnect_action_cache()
	super()

func _disable_state(toggle : bool) -> void:
	if toggle:
		_disconnect_action_cache()
		return
	_connect_action_cache()
#endregion


#region Public Virtual Methods
func action_start(_action_name : StringName) -> void:
	pass
func action_finished(_action_name : StringName) -> void:
	pass
#endregion
