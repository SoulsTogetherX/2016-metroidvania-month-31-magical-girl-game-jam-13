extends StatusEffectHandler


#region Enums
const STATUS_TYPE := StatusEffect.STATUS_TYPE
#endregion


#region External Variables
@export_group("Modules")
@export var blackboard : Blackboard
#endregion



#region Private Method
func _on_effect_started(status : StatusEffect) -> void:
	match status.type:
		STATUS_TYPE.STUN:
			blackboard.set_value(
				GlobalLabels.bh_blackboard.STATUS_STUN,
				true
			)
func _on_effect_finished(status : StatusEffect) -> void:
	match status.type:
		STATUS_TYPE.STUN:
			blackboard.set_value(
				GlobalLabels.bh_blackboard.STATUS_STUN,
				false
			)
#endregion
