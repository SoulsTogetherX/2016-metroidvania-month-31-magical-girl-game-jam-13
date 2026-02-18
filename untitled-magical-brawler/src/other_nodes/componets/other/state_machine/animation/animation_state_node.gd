@abstract
class_name AnimationStateNode extends StateNode


#region External Variables
@export var start_animation_name : StringName
@export var end_animation_name : StringName
#endregion



#region Public Methods (Animation)
func play_animation(player : AnimationPlayer, animation : StringName) -> void:
	if !player || animation.is_empty():
		return
	if !player.has_animation(animation):
		push_error(
			"AnimationPlayer does not have animation '%s'" % animation
		)
		return
	
	player.play(animation)
#endregion


#region Private Methods (State Change)
func _start_animation(player : AnimationPlayer) -> void:
	play_animation(player, start_animation_name)
func _end_animation(player : AnimationPlayer) -> void:
	play_animation(player, end_animation_name)
#endregion
