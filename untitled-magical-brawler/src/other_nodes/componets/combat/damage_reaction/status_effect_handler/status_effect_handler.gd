@abstract
class_name StatusEffectHandler extends Node


#region External Variables
@export var recevier : StatusEffectReceiverBase:
	set = set_recevier
#endregion



#region Private Method
@abstract
func _on_effect_started(status : StatusEffect) -> void
@abstract
func _on_effect_finished(status : StatusEffect) -> void
#endregion


#region Public Method
func set_recevier(val : StatusEffectReceiverBase) -> void:
	if val == recevier:
		return
	
	if recevier:
		recevier.effect_started.disconnect(_on_effect_started)
		recevier.effect_finished.disconnect(_on_effect_finished)
	recevier = val
	if recevier:
		recevier.effect_started.connect(_on_effect_started)
		recevier.effect_finished.connect(_on_effect_finished)
#endregion
