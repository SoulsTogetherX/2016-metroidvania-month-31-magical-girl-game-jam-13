extends StateActionNode


#region External Variables
@export_group("Modules")
@export var ability_cache : AbilityCacheModule

@export_group("States")
@export var normal_state : StateNode
#endregion



#region Public Virtual Methods
func action_start(action_name : StringName) -> void:
	match action_name:
		&"ability_use":
			print(
				"Activated ability: ", ability_cache.get_current_ability().ability_name
			)
			force_change(normal_state)
#endregion
