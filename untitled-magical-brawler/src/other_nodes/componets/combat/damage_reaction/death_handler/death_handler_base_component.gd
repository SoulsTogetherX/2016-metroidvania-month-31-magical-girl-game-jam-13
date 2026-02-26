@abstract
class_name DeathHandlerBaseComponent extends Node


#region Enums
enum DEATH_TYPE {
	NORMAL,
	CRUSHED
}
#endregion


#region Private Variables
var _type : DEATH_TYPE = DEATH_TYPE.NORMAL
#endregion



#region Private Methods
func _attempt_death(health : HealthComponent) -> void:
	if health.is_dead():
		_on_death(_type)
	_type = DEATH_TYPE.NORMAL

@abstract
func _on_death(type : DEATH_TYPE) -> void
#endregion


#region Public Methods
func set_death_type(type : DEATH_TYPE) -> void:
	_type = type
#endregion
