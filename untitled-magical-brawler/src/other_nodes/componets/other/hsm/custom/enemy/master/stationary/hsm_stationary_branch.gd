extends HSMBranch


#region External Variables
@export_group("States")
@export var idle_state : HSMBranch
@export var slowdown_state : HSMBranch
#endregion



#region Private Methods
func _end_wander_pause() -> void:
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


#region Public State Change Methods
func passthrough_state(_act : Node, _ctx : HSMContext) -> HSMBranch:
	return _get_expected_state()

func enter_state(act : Node, _ctx : HSMContext) -> void:
	var enemy : Enemy = act
	var vel : VelocityComponent = enemy.get_velocity_component()
	vel.hor_velocity_changed.connect(_velocity_changed)
func exit_state(act : Node, _ctx : HSMContext) -> void:
	var enemy : Enemy = act
	var vel : VelocityComponent = enemy.get_velocity_component()
	vel.hor_velocity_changed.disconnect(_velocity_changed)
#endregion
