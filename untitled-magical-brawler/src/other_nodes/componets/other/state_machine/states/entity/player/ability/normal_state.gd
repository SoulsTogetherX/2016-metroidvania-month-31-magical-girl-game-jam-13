extends StateActionNode


#region External Variables
@export_group("Modules")
@export var health_module : HealthComponent
@export var ability_cache : AbilityCacheModule

@export_group("States")
@export var select_state : StateNode
@export var ability_state : StateNode
#endregion



#region Public Virtual Methods
func action_start(action_name : StringName) -> void:
	if health_module.is_dead():
		return
	if action_cache.get_value(&"hurt"):
		return
	
	match action_name:
		&"ability_select":
			var ability := ability_cache.get_current_ability()
			if ability == null || !ability.is_vaild(action_cache):
				return
			
			force_change(select_state)
		&"ability_use":
			if ability_cache.is_empty():
				return
			
			force_change(ability_state)
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	action_cache.set_value(&"hault_input_checks", false)
func exit_state() -> void:
	action_cache.set_value(&"hault_input_checks", true)
#endregion
