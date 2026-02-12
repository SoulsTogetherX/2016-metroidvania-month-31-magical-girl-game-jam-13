class_name ActionCacheComponent extends Node


#region Enum
enum QUICK_CHECK {
	UNPRESSED     = 0b00,
	JUST_PRESSED  = 0b01,
	JUST_RELEASED = 0b10,
	HELD          = 0b11,
}
#endregion


#region External Variables
@export_group("Settings")
@export var jump_number := 1

@export_group("Other")
@export var jump_buffer : Timer
#endregion


#region Private Variables
var _jump_counter : int
var _horizontal_cache : float

var _on_jump : int
var _on_ground : int
var _on_ceiling : int
var _on_wall : int
var _on_move : int
var _on_attack : int
#endregion



#region Virtual Methods
func _ready() -> void:
	if jump_buffer:
		jump_buffer.one_shot = true
#endregion


#region Public Methods (Air Checks)
func just_jumped() -> bool:
	return _on_jump & QUICK_CHECK.JUST_PRESSED
func just_stopped_jumping() -> bool:
	return _on_jump & QUICK_CHECK.JUST_RELEASED
func is_jumping() -> bool:
	return _on_jump & QUICK_CHECK.HELD

func just_landed() -> bool:
	return _on_ground & QUICK_CHECK.JUST_PRESSED
func just_airborn() -> bool:
	return _on_ground & QUICK_CHECK.JUST_RELEASED
func is_on_ground() -> bool:
	return _on_ground & QUICK_CHECK.HELD

func just_hit_ceiling() -> bool:
	return _on_ceiling & QUICK_CHECK.JUST_PRESSED
func just_fell_from_ceiling() -> bool:
	return _on_ceiling & QUICK_CHECK.JUST_RELEASED
func is_on_ceiling() -> bool:
	return _on_ceiling & QUICK_CHECK.HELD
#endregion


#region Public Methods (Wall Checks)
func just_on_wall() -> bool:
	return _on_wall & QUICK_CHECK.JUST_PRESSED
func just_off_wall() -> bool:
	return _on_wall & QUICK_CHECK.JUST_RELEASED
func is_on_wall() -> bool:
	return _on_wall & QUICK_CHECK.HELD
#endregion


#region Public Methods (Movement Checks)
func just_moved() -> bool:
	return _on_move & QUICK_CHECK.JUST_PRESSED
func just_stopped() -> bool:
	return _on_move & QUICK_CHECK.JUST_RELEASED
func is_moving() -> bool:
	return _on_move & QUICK_CHECK.HELD
#endregion


#region Public Methods (Attack Checks)
func just_attacked() -> bool:
	return _on_attack & QUICK_CHECK.JUST_PRESSED
func just_stopped_attacking() -> bool:
	return _on_attack & QUICK_CHECK.JUST_RELEASED
func is_attacking() -> bool:
	return _on_attack & QUICK_CHECK.HELD
#endregion


#region Public Methods (Measurement)
func get_move_direction() -> float:
	return _horizontal_cache

func get_jump_counter() -> int:
	return _jump_counter
#endregion


#region Public Methods (Apply)
func progress_cache(
	horizontal_direction : float,
	jumping : bool,
	grounded : bool,
	on_ceiling : bool,
	on_wall : bool,
	on_attack : bool
) -> void:
	_on_jump <<= 1
	_on_ground <<= 1
	_on_ceiling <<= 1
	_on_wall <<= 1
	_on_move <<= 1
	_on_attack <<= 1
	
	_horizontal_cache = signf(horizontal_direction)
	if grounded:
		_jump_counter = 0
	
	if jump_buffer:
		if jumping && !is_jumping():
			jump_buffer.start()
		if grounded && !jump_buffer.is_stopped():
			jumping = true
			jump_buffer.stop()
	
	_on_jump |= int(jumping && (_jump_counter <= jump_number || is_jumping()))
	_on_ground |= int(grounded)
	_on_ceiling |= int(on_ceiling)
	_on_wall |= int(on_wall)
	_on_move |= int(!is_zero_approx(_horizontal_cache))
	_on_attack |= int(on_attack)
	
	_jump_counter += int(just_jumped())
#endregion
