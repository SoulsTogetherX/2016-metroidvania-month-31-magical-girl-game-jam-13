extends HSMBranch


#region External Variables
@export_group("States")
@export var idle_state : HSMBranch
@export var slowdown_state : HSMBranch

@export_group("Other")
@export var idle_timer : Timer
#endregion



#region Private Methods
func _ready() -> void:
	idle_timer.timeout.connect(_end_idle_pause)
#endregion


#region Private Methods
func _end_idle_pause() -> void:
	var enemy : Enemy = get_actor()
	enemy.update_patrol_point()
func _velocity_changed() -> void:
	change_state(_get_expected_state())

func _get_expected_state() -> HSMBranch:
	var act : BaseEntity = get_actor()
	var vel := act.get_velocity_component()
	
	if vel.attempting_idle():
		return idle_state
	return slowdown_state
#endregion


#region Public Virtual Methods
func action_finished(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_PURSUING_PLAYER:
			var enemy : Enemy = get_actor()
			if enemy.patrol_type != Enemy.PATROL_TYPE.NONE:
				idle_timer.start()
#endregion


#region Public State Change Methods
func passthrough_state(_act : Node, _ctx : HSMContext) -> HSMBranch:
	return _get_expected_state()

func enter_state(act : Node, ctx : HSMContext) -> void:
	var enemy : Enemy = act
	var vel : VelocityComponent = enemy.get_velocity_component()
	vel.hor_velocity_changed.connect(_velocity_changed)
	
	if (
		enemy.patrol_type != Enemy.PATROL_TYPE.NONE && 
		!ctx.is_action(GlobalLabels.hsm_context.ACT_PURSUING_PLAYER)
	):
		idle_timer.start()
func exit_state(act : Node, _ctx : HSMContext) -> void:
	var enemy : Enemy = act
	var vel : VelocityComponent = enemy.get_velocity_component()
	vel.hor_velocity_changed.disconnect(_velocity_changed)
	
	idle_timer.stop()
#endregion
