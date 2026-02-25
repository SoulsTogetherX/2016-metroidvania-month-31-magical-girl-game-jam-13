extends StateNode


#region Enums
const ABILITY_TYPE := AbilityData.ABILITY_TYPE
#endregion


#region External Variables
@export_group("Modules")
@export var ability_cache : AbilityCacheModule

@export_group("States")
@export var normal_state : StateNode
@export_subgroup("Abilities")
@export var dig_ability_state : StateNode
#endregion



#region Public Methods (State Change)
func state_passthrough() -> StateNode:
	var ability := ability_cache.get_current_ability()
	match ability.get_ability_type():
		ABILITY_TYPE.DIG:
			return dig_ability_state
	
	return normal_state
#endregion
