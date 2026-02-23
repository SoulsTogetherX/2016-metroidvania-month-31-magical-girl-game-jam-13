@tool
class_name AbilityCacheModule extends Node


#region External Variables
@export_group("Abilties")
@export var abilties : Array[AbilityResource]:
	set = set_abilities
@export var abilty_idx : int:
	set = set_abilty_idx,
	get = get_abilty_idx
#endregion


#region Private Variables
var _abilty_idx : int
#endregion



#region Public Methods
func set_abilities(val : Array[AbilityResource]) -> void:
	abilties = val
	for idx : int in range(abilties.size()):
		if abilties[idx] == null:
			abilties[idx] = AbilityResource.new()
	
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



#region Public Methods (Helper)
func get_current_ability() -> AbilityResource:
	if abilties.is_empty():
		return null
	return abilties[_abilty_idx]

func prev() -> void:
	set_abilty_idx(_abilty_idx - 1) 
func next() -> void:
	set_abilty_idx(_abilty_idx + 1) 
#endregion
