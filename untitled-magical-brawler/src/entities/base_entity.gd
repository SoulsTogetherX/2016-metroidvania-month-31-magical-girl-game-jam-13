@tool
class_name BaseEntity extends CharacterBody2D


#region External Variables
@export var faction : Constants.FACTION
#endregion



#region Public Methods (Accessor)
func toggle_brain(toggle : bool = true) -> void:
	get_manager().toggle_brain(toggle)
#endregion


#region Public Methods (Accessor)
func get_faction() -> Constants.FACTION:
	return faction
func get_manager() -> BaseEntityManager:
	return owner
#endregion
