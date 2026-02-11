class_name HitboxComponent extends Area2D


#region Signals
signal made_collision
#endregion


#region External Variables
@export var damage : int = 1
@export var trigger_invinciblity : bool = true
#endregion



#region Virtual Methods
func _ready() -> void:
	monitoring = false
	monitorable = true
#endregion



#region Public Methods
func enact_collision(
	health : HealthComponent,
	invic : InvincibilityComponent
) -> void:
	if invic && trigger_invinciblity:
		if invic.is_invincible():
			return
		invic.push_invincible()
	
	if health:
		health.damage(damage)
		made_collision.emit()
#endregion
