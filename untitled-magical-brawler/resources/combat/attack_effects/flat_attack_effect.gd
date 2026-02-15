class_name FlatAttackEffect extends BaseAttackEffect


#region External Variables
@export var damage : int = 1
#endregion



#region Public Virtual Methods
func implement_attack(health : HealthComponent) -> void:
	health.damage(damage)
#endregion
