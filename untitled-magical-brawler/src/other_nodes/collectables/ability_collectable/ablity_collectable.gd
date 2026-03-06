@tool
extends Node2D


#region External Variables
@export var ability : AbilityData:
	set(val):
		if val == ability:
			return
		ability = val
		
		_load_texture()
#endregion


#region OnReady Variables
@onready var _hitbox: HitboxComponent = $Hitbox
#endregion



#region Virtual Methods
func _ready() -> void:
	if Engine.is_editor_hint():
		_load_texture()
		return
	if ability == null || Global.player.has_ability(ability.type):
		queue_free()
		return
	
	_load_texture()
	_hitbox.collision_found.connect(_on_collect)
#endregion


#region Private Methods
func _load_texture() -> void:
	if ability == null:
		return
	$Sprite2D.texture = ability.get_icon()

func _on_collect() -> void:
	if ability != null:
		Global.player.register_ability(ability.type)
	queue_free()
#endregion
