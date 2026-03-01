class_name KnockbackEffect extends CombatEffect


#region Enum
enum AXIS {
	NONE = 0b00,
	X    = 0b01,
	Y    = 0b10,
	BOTH = 0b11
}
#endregion


#region External Variables
@export_group("Settings")
@export var enact_on_dead : bool = true
@export var dynamic_direction : bool = true

@export_group("Force")
@export_range(0, TAU, 0.001) var angle_offset : float
@export_range(
	0, 10000, 0.001, "or_greater"
) var knockback_power : float = 2000

@export_group("Axis")
@export_flags(
	"Overwrite X:1", "Overwrite Y:2"
) var overwrite_motion : int = 1

@export_flags(
	"Ignore X:1", "Ignore Y:2"
) var axis_ignore : int
#endregion



#region Public Virtual Methods
func implement_attack(collide_info : CollisionInfoResource) -> void:
	if !enact_on_dead:
		var health := collide_info.health_module
		if health && health.is_dead():
			return
	
	var knockback := collide_info.knockback_module
	if !knockback:
		return
	
	var dir : Vector2
	var angle : float = angle_offset
	
	if dynamic_direction:
		var offset := collide_info.hit_offset
		angle += atan2(offset.y, offset.x)
	
	if (axis_ignore & AXIS.X) == 0:
		dir.x = cos(angle) * knockback_power
	if (axis_ignore & AXIS.Y) == 0:
		dir.y = sin(angle) * knockback_power
	
	knockback.enact_knockback(
		dir,
		(overwrite_motion & AXIS.X) != 0,
		(overwrite_motion & AXIS.Y) != 0,
	)
#endregion
