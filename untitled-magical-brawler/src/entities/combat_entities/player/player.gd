@tool
class_name Player extends CombatEntity


#region OnReady Variables
# Caches
@onready var _ability_cache: AbilityCacheModule = %AbilityCacheModule
#endregion


#region Public Methods
func has_ability(ability : AbilityData) -> bool:
	return _ability_cache.has_ability_data(ability)
func register_ability(ability : AbilityData) -> void:
	if has_ability(ability):
		return
	_ability_cache.register_ability(ability)
#endregion
