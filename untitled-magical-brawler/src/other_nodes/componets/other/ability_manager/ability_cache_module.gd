class_name AbilityCacheModule extends Node


#region Enums
const ABILITY_TYPE := AbilityData.ABILITY_TYPE
#endregion


#region Private Variables
var _abilties : Dictionary[ABILITY_TYPE, AbilityData] = {
	ABILITY_TYPE.DIG: DigAbility.new()
}
#endregion



#region Public Methods
func register_ability(data : AbilityData) -> void:
	if data == null:
		return
	_abilties.set(data.get_ability_type(), data)
#endregion


#region Public Methods (Can Checks)
func can_start(type : ABILITY_TYPE, args : Dictionary = {}) -> bool:
	var ability : AbilityData = _abilties.get(type, null)
	if ability == null:
		return false
	return ability.can_start(args)
func can_end(type : ABILITY_TYPE, args : Dictionary = {}) -> bool:
	var ability : AbilityData = _abilties.get(type, null)
	if ability == null:
		return false
	return ability.can_end(args)
#endregion


#region Public Methods (Helper)
func size() -> int:
	return _abilties.size()
func is_empty() -> bool:
	return _abilties.is_empty()

func has_ability(type : ABILITY_TYPE) -> bool:
	return _abilties.has(type)
#endregion
