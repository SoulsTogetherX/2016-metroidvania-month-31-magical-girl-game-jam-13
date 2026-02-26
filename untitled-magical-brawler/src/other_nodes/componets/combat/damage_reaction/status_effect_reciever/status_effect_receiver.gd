class_name StatusEffectReceiver extends StatusEffectReceiverBase


#region Private Variables
var _effect_cache : Dictionary[STATUS_TYPE, StatusEffect]
#endregion



#region Private Methods
func _finish_manual_effect(status : StatusEffect) -> void:
	effect_finished.emit(_effect_cache.get(status.type))
func _finish_effect(status : StatusEffect) -> void:
	effect_finished.emit(_effect_cache.get(status.type))
	_effect_cache.erase(status.type)
#endregion


#region Public Methods (Access)
func apply_effect(effect : StatusEffect) -> void:
	if effect == null:
		return
	
	var effect_old : StatusEffect = _effect_cache.get(effect.type, null)
	if effect_old == null:
		effect_started.emit(effect)
	elif effect_old == effect || effect_old.get_remaining_duration() > effect.duration:
		return
	else:
		effect_old.finished.disconnect(_finish_effect)
	
	_effect_cache.set(effect.type, effect)
	effect._start_effect(self)
	if !effect.finished.is_connected(_finish_effect):
		effect.finished.connect(_finish_effect)
	
	effect_started.emit(effect)
func get_effect(type : STATUS_TYPE) -> StatusEffect:
	return _effect_cache.get(type, null)
#endregion


#region Public Methods (Check)
func has_effect(effect : StatusEffect) -> bool:
	if effect == null:
		return false
	return get_effect(effect.type) == effect
func has_effect_type(type : STATUS_TYPE) -> bool:
	return _effect_cache.has(type)
#endregion


#region Public Methods (Removal)
func clear_effects() -> void:
	for effect : StatusEffect in _effect_cache.values():
		effect._finish_manual_effect()
	_effect_cache.clear()
func end_effect(effect : StatusEffect) -> void:
	if effect != null:
		return
	effect._end_effect()
func end_effect_type(type : STATUS_TYPE) -> void:
	var effect := get_effect(type)
	if effect == null:
		return
	effect._end_effect()
#endregion
