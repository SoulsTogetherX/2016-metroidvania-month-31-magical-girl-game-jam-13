@tool
extends ActionLeaf


#region External Variables
@export_group("Animations")
@export var animation : GlobalLabels.animations.ACTIONS
@export var overwrite : StringName

@export_group("Settings")
@export var on_enter : bool = true
#endregion



#region Public Methods (State Change)
func _play_animation(act : BaseEntity) -> void:
	var entity : BaseEntity = act
	if overwrite.is_empty():
		entity.play_animation(GlobalLabels.animations.get_label(animation))
		return
	entity.play_animation(overwrite)
#endregion


#region Public Methods (State Change)
func before_run(actor: Node, _blackboard: Blackboard) -> void:
	if !on_enter:
		return
	_play_animation(actor)
func after_run(actor: Node, _blackboard: Blackboard) -> void:
	if on_enter:
		return
	_play_animation(actor)
#endregion
