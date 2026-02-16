@tool
class_name HurtboxComponent extends FactionAreaComponent


#region Signals
signal on_hit(collision : HitboxComponent)
#endregion


#region Constants
const DEBUG_COLOR := Color(0, 1, 0, 0.3)
#endregion


#region External Variables
@export_group("Modules")
@export var knockback_module : KnockbackComponent
@export var health_module : HealthComponent
@export var invincibility_module : InvincibilityComponent

@export_group("Settings")
@export var collide_when_dead : bool = false
@export_range(0, 1, 1, "or_greater") var destroy_on_collision_count : int = 0
#endregion



#region Virtual Methods
func _init() -> void:
	monitoring = true
	monitorable = false
	area_entered.connect(_on_area_enter)

func _validate_property(property: Dictionary) -> void:
	super(property)
	if property.name in [&"monitoring", &"monitorable"]:
		property.usage &= ~PROPERTY_USAGE_EDITOR
#endregion


#region Custom Virtual Methods
func _refresh_faction() -> void:
	collision_layer = 0
	
	match faction:
		Constants.FACTION.NONE:
			collision_mask = 0
		Constants.FACTION.PLAYER:
			collision_mask = Constants.LAYERS.ENEMY
		Constants.FACTION.ENEMY:
			collision_mask = Constants.LAYERS.PLAYER
		Constants.FACTION.NEUTRAL:
			collision_mask = Constants.LAYERS.PLAYER | Constants.LAYERS.ENEMY
		_:
			collision_mask = 0

func _refresh_collider() -> void:
	super()
	if _collider:
		_collider.debug_color = DEBUG_COLOR
#endregion


#region Private Methods (Signal)
func _on_area_enter(collision : HitboxComponent) -> void:
	if collision == null:
		return
	if !collide_when_dead && health_module && health_module.is_dead():
		return
	
	collision.enact_collision(CollisionInfoResource.new(
		self.global_position - collision.global_position,
		health_module, knockback_module, invincibility_module
	))
	on_hit.emit(collision)
#endregion
