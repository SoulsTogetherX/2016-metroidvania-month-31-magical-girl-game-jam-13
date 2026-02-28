@tool
class_name Player extends CombatEntity


#region Onready Variables
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var task_manager: VelocityTaskManager = %TaskManager
@onready var ability_cache: AbilityCacheModule = %AbilityCacheModule
#endregion



#region Ability Methods
func has_ability(ability : AbilityData) -> bool:
	if ability == null:
		return false
	return ability_cache.has_ability(ability.get_ability_type())
func register_ability(ability : AbilityData) -> void:
	ability_cache.register_ability(ability)
#endregion
