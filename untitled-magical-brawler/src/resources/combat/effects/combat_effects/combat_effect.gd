@abstract
class_name CombatEffect extends BaseEffect


@export_group("Invincibility")
@export var ignore_invincibility : bool = false



#region Public Virtual Methods
func implement_effect(collide_info : CollisionInfoResource) -> void:
	var status := collide_info.status_effect_module
	if !ignore_invincibility && status && status.has_effect_type(status.STATUS_TYPE.INVINCIBILITY):
		return
	
	implement_attack(collide_info)

@abstract
func implement_attack(collide_info : CollisionInfoResource) -> void
#endregion
