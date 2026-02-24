extends StateActionNode


#region External Variables
@export_group("Modules")
@export var health_module : HealthComponent
@export var ability_cache : AbilityCacheModule

@export_group("States")
@export var state_machine: StateMachine
@export var select_state : StateNode
@export var ability_state : StateNode

@export_group("Other")
@export var entity_state_machine: StateMachine
@export var hault_state: StateNode
@export var resume_state: StateNode
#endregion



#region Private Methods
func _emergency_return() -> void:
	state_machine.force_state(self)
#endregion


#region Public Virtual Methods
func action_start(action_name : StringName) -> void:
	if health_module.is_dead():
		return
	if action_cache.get_value(&"hurt"):
		return
	if ability_cache.is_empty():
		return
	
	match action_name:
		&"ability_select":
			force_change(select_state)
		&"ability_use":
			force_change(ability_state)
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	entity_state_machine.disabled = false
	entity_state_machine.force_state(resume_state)
	
	if entity_state_machine.changed_state.is_connected(_emergency_return):
		entity_state_machine.changed_state.disconnect(_emergency_return)
func exit_state() -> void:
	entity_state_machine.force_state(hault_state, false)
	entity_state_machine.disabled = true
	
	if !entity_state_machine.changed_state.is_connected(_emergency_return):
		entity_state_machine.changed_state.connect(_emergency_return)
#endregion
