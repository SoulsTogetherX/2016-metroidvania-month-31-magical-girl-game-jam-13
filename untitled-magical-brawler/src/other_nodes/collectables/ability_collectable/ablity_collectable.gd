extends Node2D


#region External Variables
@export var ability : AbilityData:
	set(val):
		if val == ability:
			return
		ability = val
		
		_update_hitbox_effect()
#endregion


#region OnReady Variables
@onready var _hitbox: HitboxComponent = $Hitbox
#endregion



#region Virtual Methods
func _ready() -> void:
	prints(
		ability,
		Global.player.has_ability(ability)
	)
	if ability == null || Global.player.has_ability(ability):
		queue_free()
		return
	
	_update_hitbox_effect()
	_load_texture()
	_hitbox.collision_found.connect(_on_collect)
#endregion


#region Private Methods
func _update_hitbox_effect() -> void:
	if _hitbox == null:
		return
	
	var upgrade := UpgradeCollectableEffect.new()
	upgrade.ability = ability
	
	_hitbox.effects = [upgrade]

func _load_texture() -> void:
	pass

func _on_collect() -> void:
	if ability != null:
		Global.player.register_ability(ability)
	queue_free()
#endregion
