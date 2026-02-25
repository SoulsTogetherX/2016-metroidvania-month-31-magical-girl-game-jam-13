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
		&"player_left":
			ability_cache.prev()
		&"player_right":
			ability_cache.next()
		&"ability_select":
			force_change(normal_state)
#endregion
