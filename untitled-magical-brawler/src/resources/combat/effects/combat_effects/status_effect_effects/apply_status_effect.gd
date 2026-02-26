class_name ApplyStatusEffect extends CombatEffect


#region External Variables
@export_group("Settings")
@export var status : StatusEffect
#endregion



#region Public Virtual Methods
func implement_attack(collide_info : CollisionInfoResource) -> void:
	var recevier := collide_info.status_effect_module
	if recevier:
		recevier.apply_effect(status)
#endregion
