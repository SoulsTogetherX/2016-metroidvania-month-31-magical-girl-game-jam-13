class_name CollisionInfoResource extends Resource


#region Private Variables
var _hit_offset : Vector2
var _health_module : HealthComponent
var _knockback_module : KnockbackComponent
var _invincibility_module : InvincibilityComponent
#endregion



#region Virtual Methods
func _init(
	offset : Vector2,
	health_module : HealthComponent,
	knockback_module : KnockbackComponent,
	invincibility_module : InvincibilityComponent
) -> void:
	_hit_offset = offset
	_health_module = health_module
	_knockback_module = knockback_module
	_invincibility_module = invincibility_module
#endregion


#region Public Methods (Accessor)
func get_hit_offset() -> Vector2:
	return _hit_offset

func get_health_module() -> HealthComponent:
	return _health_module
func get_knockback_module() -> KnockbackComponent:
	return _knockback_module
func get_invincibility_module() -> InvincibilityComponent:
	return _invincibility_module
#endregion
