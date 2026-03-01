@tool
extends Node2D


#region External Variables
@export var ability : AbilityData:
	set(val):
		if val == ability:
			return
		ability = val
		
		_update_hitbox_effect()
		_load_texture()
@export var shape : Shape2D:
	set(val):
		if val == shape:
			return
		if val == null:
			val = CircleShape2D.new()
		shape = val
		
		_update_hitbox_shape()
#endregion


#region OnReady Variables
@onready var _hitbox: HitboxComponent = $Hitbox
#endregion



#region Virtual Methods
func _ready() -> void:
	if Engine.is_editor_hint():
		_load_texture()
		return
	if ability == null || Global.player.has_ability(ability):
		queue_free()
		return
	
	_update_hitbox_effect()
	_load_texture()
	_update_hitbox_shape()
	_hitbox.collision_found.connect(_on_collect)
#endregion


#region Private Methods
func _update_hitbox_effect() -> void:
	if !is_node_ready():
		return
	
	var upgrade := UpgradeCollectableEffect.new()
	upgrade.ability = ability
	_hitbox.effects = [upgrade]
func _update_hitbox_shape() -> void:
	if !is_node_ready():
		return
	_hitbox.shape = shape

func _load_texture() -> void:
	if ability == null:
		return
	$Sprite2D.texture = ability.get_icon()

func _on_collect() -> void:
	if ability != null:
		Global.player.register_ability(ability)
	queue_free()
#endregion
