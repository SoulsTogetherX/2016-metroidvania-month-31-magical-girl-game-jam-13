class_name FlatHealthEffect extends AttackEffect


#region External Variables
@export_group("Settings")
@export var damage : int = 1
#endregion



#region Public Virtual Methods
func implement_attack(collide_info : CollisionInfoResource) -> void:
	var health_module := collide_info.get_health_module()
	if health_module:
		health_module.damage(damage)
#endregion
