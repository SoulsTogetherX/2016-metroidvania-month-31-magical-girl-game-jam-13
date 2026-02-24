@abstract
class_name StateActionConditional extends StateConditional


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent
#endregion



#region Public Virtual Methods
func action_start(_action_name : StringName) -> StateNode:
	return null
func action_finished(_action_name : StringName) -> StateNode:
	return null
#endregion
