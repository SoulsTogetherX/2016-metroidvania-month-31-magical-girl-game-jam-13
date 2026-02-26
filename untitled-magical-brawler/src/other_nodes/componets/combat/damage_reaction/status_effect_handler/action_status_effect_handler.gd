extends StatusEffectHandler


#region Enums
const STATUS_TYPE := StatusEffect.STATUS_TYPE
#endregion


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent

@export_group("Actions")
@export var action_stun : StringName
#endregion



#region Private Method
func _on_effect_started(status : StatusEffect) -> void:
	match status.type:
		STATUS_TYPE.STUN:
			action_cache.set_action(action_stun, true)
func _on_effect_finished(status : StatusEffect) -> void:
	match status.type:
		STATUS_TYPE.STUN:
			action_cache.set_action(action_stun, false)
#endregion
