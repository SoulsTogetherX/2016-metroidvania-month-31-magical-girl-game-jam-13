@abstract
class_name AttackEffect extends BaseEffect


@export_group("Invincibility")
@export var ignore_invincibility : bool = false
@export var trigger_invincibility : bool = true



#region Public Virtual Methods
func implement_effect(collide_info : CollisionInfoResource) -> void:
	var inv := collide_info.invincibility_module
	if inv && !ignore_invincibility && inv.is_invincible():
		return
	
	implement_attack(collide_info)
	
	if inv && trigger_invincibility && !inv.is_invincible():
		inv.queue_invinciblity()

@abstract
func implement_attack(collide_info : CollisionInfoResource) -> void
#endregion
