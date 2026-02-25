extends StateModule


#region External Variables
@export_group("Modules")
@export var animation_player : AnimationPlayer

@export_group("Animations")
@export var begin : StringName
@export var end : StringName
#endregion



#region Public Methods (State Change)
func enter_state() -> void:
	if begin.is_empty():
		return
	animation_player.play(begin)
func exit_state() -> void:
	if end.is_empty():
		return
	animation_player.play(end)
