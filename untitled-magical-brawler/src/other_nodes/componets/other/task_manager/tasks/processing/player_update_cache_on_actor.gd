extends TaskNode


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent

@export_group("Other")
@export var actor : CharacterBody2D
#endregion


#region Private Variables
var _action_cache : ActionCacheComponent

var _actor : CharacterBody2D
#endregion



#region Virtual Methods
func _ready() -> void:
	need_physics = true
#endregion


#region Public Virtual Methods
func task_physics(_delta : float) -> void:
	var move_dir := int(
			Input.is_action_pressed(&"player_right")
		) - int(
			Input.is_action_pressed(&"player_left")
		)
	
	# Base Controls
	_action_cache.set_action(
		&"player_left", Input.is_action_pressed(&"player_left")
	)
	_action_cache.set_action(
		&"player_right", Input.is_action_pressed(&"player_right")
	)
	_action_cache.set_action(
		&"player_up", Input.is_action_pressed(&"player_up")
	)
	_action_cache.set_action(
		&"player_down", Input.is_action_pressed(&"player_down")
	)
	
	# Ability Controls
	_action_cache.set_action(
		&"ability_use", Input.is_action_pressed(&"player_ability")
	)
	_action_cache.set_action(
		&"ability_select", Input.is_action_pressed(&"player_ability_select")
	)
	
	# Input Checks
	if _action_cache.get_value(&"hault_input_checks"):
		_action_cache.set_action(&"moving", false)
		_action_cache.set_action(&"player_jump", false)
		_action_cache.set_action(&"player_attack", false)
	else:
		_action_cache.set_action(&"moving", move_dir != 0)
		_action_cache.set_action(
			&"player_jump", Input.is_action_pressed(&"player_jump")
		)
		_action_cache.set_action(
			&"player_attack", Input.is_action_pressed(&"player_attack")
		)
	
	# States Checks
	_action_cache.set_action(
		&"in_air", !_actor.is_on_floor()
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
	
	return true
#endregion
