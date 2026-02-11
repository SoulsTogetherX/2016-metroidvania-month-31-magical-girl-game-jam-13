class_name HurtboxComponent extends Area2D


#region Signals
signal on_hit(collision : HitboxComponent, invic : InvincibilityComponent)
#endregion


#region External Variables
@export var health : HealthComponent
@export var invic : InvincibilityComponent
#endregion



#region Virtual Methods
func _ready() -> void:
	monitoring = true
	monitorable = false
	area_entered.connect(_on_area_enter)
#endregion


#region Signal Methods
func _on_area_enter(collision : HitboxComponent) -> void:
	if collision == null:
		return
	
	collision.enact_collision(health, invic)
	on_hit.emit(collision, invic)
#endregion
