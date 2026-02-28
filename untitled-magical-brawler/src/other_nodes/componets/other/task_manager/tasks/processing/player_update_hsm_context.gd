extends TaskNode


#region External Variables
@export_group("Modules")
@export var context : HSMContext

@export_group("Other")
@export var actor : CharacterBody2D
#endregion


#region Private Variables
var _context : HSMContext

var _actor : CharacterBody2D
#endregion



#region Virtual Methods
func _ready() -> void:
	need_physics = true
#endregion


#region Public Virtual Methods
func task_physics(_delta : float) -> void:
	var labels := GlobalLabels.hsm_context
	var move_dir := Input.get_axis(
		&"player_left", &"player_right"
	)
	
	# Base Controls
	_context.set_action(
		labels.ACT_PLAYER_LEFT, Input.is_action_pressed(&"player_left")
	)
	_context.set_action(
		labels.ACT_PLAYER_RIGHT, Input.is_action_pressed(&"player_right")
	)
	_context.set_action(
		labels.ACT_PLAYER_UP, Input.is_action_pressed(&"player_up")
	)
	_context.set_action(
		labels.ACT_PLAYER_DOWN, Input.is_action_pressed(&"player_down")
	)
	
	# Ability Controls
	_context.set_action(
		labels.ACT_PLAYER_DIG, Input.is_action_pressed(&"player_dig")
	)
	
	# Input Checks
	_context.set_action(labels.ACT_MOVING, move_dir != 0)
	_context.set_action(
		labels.ACT_JUMPING, Input.is_action_pressed(&"player_jump")
	)
	_context.set_action(
		labels.ACT_ATTACKING, Input.is_action_pressed(&"player_attack")
	)
	
	# States Checks
	_context.set_action(
		labels.ACT_IN_AIR, !_actor.is_on_floor()
	)
	_context.set_action(
		labels.ACT_ON_CEIlING, _actor.is_on_ceiling()
	)
	_context.set_action(
		labels.ACT_ON_WALL, _actor.is_on_wall()
	)
	
	# Helper States
	_context.set_value(
		labels.VAL_H_DIR, move_dir
	)
#endregion
	

#region Public Methods (Action States)
func task_passthrough() -> bool:
	_actor = args.get(&"actor", actor)
	if _actor == null:
		return false
	
	_context = args.get(&"context", context)
	if _context == null:
		return false
	
	return true
#endregion
