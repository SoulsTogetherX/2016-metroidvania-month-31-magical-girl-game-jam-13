@abstract
class_name StateActionNode extends StateNode


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent
#endregion



#region Private Methods
func _enter_state() -> void:
	if action_cache:
		action_cache.action_started.connect(action_start)
		action_cache.action_finished.connect(action_finished)
	super()
func _exit_state() -> void:
	if action_cache:
		action_cache.action_started.disconnect(action_start)
		action_cache.action_finished.disconnect(action_finished)
	super()
#endregion


#region Public Virtual Methods
func action_start(_action_name : StringName) -> void:
	pass
func action_finished(_action_name : StringName) -> void:
	pass
#endregion
