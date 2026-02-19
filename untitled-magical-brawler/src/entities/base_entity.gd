@tool
class_name BaseEntity extends CharacterBody2D


#region External Variables
@export var faction : Constants.FACTION
@export var visual_piviot : Node2D
#endregion


#region Private Variables
var _manager : BaseEntityManager
#endregion



#region Public Methods (Accessor)
func toggle_brain(toggle : bool = true) -> void:
	get_manager().toggle_brain(toggle)
#endregion


#region Public Methods (Accessor)
func get_faction() -> Constants.FACTION:
	return faction
func get_manager() -> BaseEntityManager:
	return _manager
#endregion


#region Public Methods (Helper)
func set_manager(manager : BaseEntityManager) -> void:
	_manager = manager
func change_direction(flip_h : bool, flip_v : bool) -> void:
	visual_piviot.scale = Vector2(
		-1 if flip_h else 1,
		-1 if flip_v else 1
	)
#endregion
