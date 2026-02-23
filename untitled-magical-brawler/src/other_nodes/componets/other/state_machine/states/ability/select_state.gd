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
			print(
				"Prev to ability: ", ability_cache.get_current_ability().ability_name
			)
		&"player_right":
			ability_cache.next()
			print(
				"Next to ability: ", ability_cache.get_current_ability().ability_name
			)
		&"ability_use":
			force_change(normal_state)
#endregion
