@abstract
class_name StateActionNode extends StateNode


#region Constants
const ACTION_STATE = ActionCacheComponent.ACTION_STATE
#endregion


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent

@export_group("Settings")
@export var check_state : ACTION_STATE = ACTION_STATE.HELD
@export var state : StringName

@export_group("Settings")
@export var resulting_state : StateNode
#endregion


func check_condition() -> StateNode:
	
	
	return null
