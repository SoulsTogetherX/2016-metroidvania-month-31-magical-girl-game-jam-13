extends HSMBranch


#region External Variables
@export_group("States")
@export var jump_state : HSMBranch
@export var ground_state : HSMBranch

@export_group("Other")
@export var coyote_timer : Timer
@export var jump_buffer : Timer
#endregion



#region Virtual Methods
func _ready() -> void:
	if !coyote_timer:
		return
	coyote_timer.one_shot = true
#endregion


#region Public Virtual Methods
func action_started(action_name : StringName) -> void:
	var ctx := get_context()
	
	match action_name:
		GlobalLabels.hsm_context.ACT_JUMPING:
			if (
				!ctx.get_value(&"has_jumped") &&
				coyote_timer &&
				!coyote_timer.is_stopped()
			):
				coyote_timer.stop()
				change_state(jump_state)
				return
			
			if jump_buffer:
				jump_buffer.start()
func action_finished(action_name : StringName) -> void:
	var ctx := get_context()
	
	match action_name:
		GlobalLabels.hsm_context.ACT_IN_AIR:
			if jump_buffer && !jump_buffer.is_stopped():
				change_state(jump_state)
				return
			ctx.set_value(&"has_jumped", false)
			change_state(ground_state)
#endregion


#region Public Methods (State Change)
func enter_state(_act : Node, ctx : HSMContext) -> void:
	if !coyote_timer:
		return
	
	if !ctx.get_value(&"jumped"):
		coyote_timer.start()
#endregion
