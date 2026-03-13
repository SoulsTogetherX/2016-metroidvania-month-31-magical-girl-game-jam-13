@tool
extends Node2D


#region Constants
const ABILITY_GET_ANIMATION_NAME := "ABILITY_GET"
#endregion


#region External Variables
@export var ability : AbilityData:
	set(val):
		if val == ability:
			return
		ability = val
		
		_load_texture()
#endregion


#region OnReady Variables
@onready var _particles: OneshotParticles = %CollectableParticles
@onready var _player: AnimationPlayer = %AnimationPlayer

@onready var _icon: Sprite2D = %Icon
@onready var _hitbox: HitboxComponent = %Hitbox
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
	if ability == null || _icon == null:
		return
	_icon.texture = ability.get_icon()

func _on_collect() -> void:
	_particles.start_final_emit(owner)
	
	if ability != null:
		_player.play(ABILITY_GET_ANIMATION_NAME)
		Global.player.register_ability(ability.type)
		await Global.player.play_ability_gain_animation()
		
		var control := Global.local_controller
		if control is RoomManager:
			control.display_ability(ability)
	
	queue_free()
#endregion
