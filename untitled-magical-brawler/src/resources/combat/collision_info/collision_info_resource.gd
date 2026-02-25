class_name CollisionInfoResource extends Resource


#region Private Variables
var hit_offset : Vector2
var entity : BaseEntity
var health_module : HealthComponent
var knockback_module : KnockbackComponent
var invincibility_module : InvincibilityComponent
#endregion



#region Virtual Methods
func _init(
	offset : Vector2,
	base_entity : BaseEntity,
	health : HealthComponent,
	knockback : KnockbackComponent,
	invincibility : InvincibilityComponent
) -> void:
	hit_offset = offset
	entity = base_entity
	health_module = health
	knockback_module = knockback
	invincibility_module = invincibility
#endregion
