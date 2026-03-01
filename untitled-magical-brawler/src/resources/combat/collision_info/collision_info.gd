class_name CollisionInfoResource extends Resource


#region Private Variables
var hit_offset : Vector2

var entity : BaseEntity
var health_module : HealthComponent
var knockback_module : KnockbackComponent
var status_effect_module : StatusEffectReceiver
#endregion



#region Virtual Methods
func _init(
	offset : Vector2,
	base_entity : BaseEntity,
	health : HealthComponent,
	knockback : KnockbackComponent,
	status_effect : StatusEffectReceiver
) -> void:
	hit_offset = offset
	
	entity = base_entity
	health_module = health
	knockback_module = knockback
	status_effect_module = status_effect
#endregion
