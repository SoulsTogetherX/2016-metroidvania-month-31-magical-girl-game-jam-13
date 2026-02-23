extends TaskNode


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent
@export var input_access : PlayerInputComponent

@export_group("Other")
@export var actor : CharacterBody2D
#endregion


#region Private Variables
var _action_cache : ActionCacheComponent
var _input_access : PlayerInputComponent

var _actor : CharacterBody2D
#endregion



#region Virtual Methods
func _ready() -> void:
	need_physics = true
#endregion


#region Public Virtual Methods
func task_physics(_delta : float) -> void:
	var move_dir := int(_input_access.right_press()) - int(_input_access.left_press())
	
	# Base Controls
	_action_cache.set_action(
		&"player_left", _input_access.left_press()
	)
	_action_cache.set_action(
		&"player_right", _input_access.right_press()
	)
	_action_cache.set_action(
		&"player_up", _input_access.up_press()
	)
	_action_cache.set_action(
		&"player_down", _input_access.down_press()
	)
	
	# Special Controls
	_action_cache.set_action(
		&"player_jump", _input_access.jump_press()
	)
	_action_cache.set_action(
		&"player_attack", _input_access.attack_press()
	)
	
	# Ability Controls
	_action_cache.set_action(
		&"ability_use", _input_access.activate_ability()
	)
	_action_cache.set_action(
		&"ability_select", _input_access.activate_ability_select()
	)
	
	# Base States
	_action_cache.set_action(
		&"moving", move_dir != 0
	)
	
	_action_cache.set_action(
		&"on_floor", _actor.is_on_floor()
	)
	_action_cache.set_action(
		&"on_ceiling", _actor.is_on_ceiling()
	)
	_action_cache.set_action(
		&"on_wall", _actor.is_on_wall()
	)
	
	# Helper States
	action_cache.set_value(
		&"h_direction", move_dir
	)
#endregion
	

#region Public Methods (Action States)
func task_passthrough() -> bool:
	_actor = args.get(&"actor", actor)
	if _actor == null:
		return false
	
	_action_cache = args.get(&"action_cache", action_cache)
	if _action_cache == null:
		return false
	
	_input_access = args.get(&"input_access", input_access)
	if _input_access == null:
		return false
	
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Update_Cache_Task"
#endregion
