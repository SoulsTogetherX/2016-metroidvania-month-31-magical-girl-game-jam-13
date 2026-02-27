extends Node


#region External Variables
@export var blackboard : Blackboard
#endregion



#region Public Methods
func _detected_player_enter(body : Node2D) -> void:
	if !(body is Player):
		return
	blackboard.set_value(
		GlobalLabels.bh_blackboard.PLAYER,
		body
	)
	blackboard.set_value(
		GlobalLabels.bh_blackboard.DETECTED_PLAYER,
		true
	)
func _detected_player_exit(body : Node2D) -> void:
	if !(body is Player):
		return
	blackboard.set_value(
		GlobalLabels.bh_blackboard.DETECTED_PLAYER,
		false
	)
#endregion
