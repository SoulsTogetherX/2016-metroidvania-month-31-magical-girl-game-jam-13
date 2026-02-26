extends Node


#region External Variables
@export var receiver : StatusEffectReceiverBase
@export var effect : StatusEffect
#endregion



#region Public Methods
func force_effect() -> void:
	receiver.apply_effect(effect)
#endregion
