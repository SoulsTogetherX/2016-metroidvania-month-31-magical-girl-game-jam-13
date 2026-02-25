extends StateActionConditional


#region External Variables
@export_group("Modules")
@export var ability_cache : AbilityCacheModule

@export_group("States")
@export var select_state : StateNode
@export var ability_state : StateNode

@export_group("Actions")
@export var select_action : StringName = &"ability_select"
@export var ability_action : StringName = &"ability_use"
#endregion



#region Public Methods (State Change)
func conditional_check() -> StateNode:
	return null
#endregion


#region Public Virtual Methods
func action_start(action_name : StringName) -> StateNode:
	match action_name:
		select_action:
			if ability_cache.size() > 1:
				return select_state
		ability_action:
			if !ability_cache.is_empty():
				return ability_state
	return null
#endregion
