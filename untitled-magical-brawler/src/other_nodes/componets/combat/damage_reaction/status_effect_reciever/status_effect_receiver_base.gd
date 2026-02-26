@abstract
class_name StatusEffectReceiverBase extends Node


#region Signals
@warning_ignore("unused_signal")
signal effect_started(status : StatusEffect)
@warning_ignore("unused_signal")
signal effect_finished(status : StatusEffect)
#endregion


#region Enums
const STATUS_TYPE := StatusEffect.STATUS_TYPE
#endregion



#region Public Methods (Access)
func apply_effect_manual(
	type : STATUS_TYPE, duration : float = 1.0,
	metadata : Dictionary = {}
) -> void:
	var status := StatusEffect.new()
	status.type = type
	status.duration = duration
	status.metadata = metadata
	
	apply_effect(status)
@abstract
func apply_effect(effect : StatusEffect) -> void

@abstract
func get_effect(type : STATUS_TYPE)
#endregion


#region Public Methods (Check)
@abstract
func has_effect(effect : StatusEffect) -> bool
@abstract
func has_effect_type(type : STATUS_TYPE) -> bool
#endregion


#region Public Methods (Remove)
@abstract
func clear_effects() -> void
@abstract
func end_effect(effect : StatusEffect) -> void
@abstract
func end_effect_type(type : STATUS_TYPE) -> void
#endregion
