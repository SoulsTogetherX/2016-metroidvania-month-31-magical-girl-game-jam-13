class_name AbilityCacheModule extends Node


#region Public Variables
@export var abilties : Array[AbilityData]:
	set = set_abilities
var abilty_idx : int:
	set = set_abilty_idx,
	get = get_abilty_idx
#endregion


#region Private Variables
var _abilty_idx : int
#endregion



#region Public Methods
func set_abilities(val : Array[AbilityData]) -> void:
	abilties = val
	if abilties.is_empty():
		_abilty_idx = -1
		return
	
	_abilty_idx = posmod(abilty_idx, abilties.size())

func set_abilty_idx(val : int) -> void:
	if abilties.is_empty():
		_abilty_idx = -1
		return
	_abilty_idx = posmod(val, abilties.size())
func get_abilty_idx() -> int:
	return _abilty_idx
#endregion


#region Public Methods (Can Checks)
func can_start(args : Dictionary = {}) -> bool:
	if is_empty():
		return false
	return get_current_ability().can_start(args)
func can_end(args : Dictionary = {}) -> bool:
	if is_empty():
		return false
	return get_current_ability().can_end(args)
#endregion


#region Public Methods (Helper)
func get_current_ability() -> AbilityData:
	if is_empty():
		return null
	return abilties[_abilty_idx]
func is_empty() -> bool:
	return abilties.is_empty()

func prev() -> void:
	set_abilty_idx(_abilty_idx - 1) 
func next() -> void:
	set_abilty_idx(_abilty_idx + 1) 
#endregion
