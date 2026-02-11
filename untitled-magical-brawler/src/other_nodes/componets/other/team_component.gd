@tool
class_name TeamComponent extends Node


#region Enums
enum TEAM {
	NONE   = 0b0000000000000000,
	GROUND = 0b0000000000000001,
	PLAYER = 0b0000000000000010,
	ENEMY  = 0b0000000000000100
}
#endregion


#region External Variables
@export var collisions : Array[CollisionObject2D]:
	set(val):
		collisions = val
		_update_collisons()
@export var team : TEAM:
	set(val):
		if val == team:
			return
		team = val
		_update_collisons()
#endregion



#region Virtual Methods
func _ready() -> void:
	_update_collisons()
#endregion


#region Private Methods
func _update_collisons() -> void:
	for col : CollisionObject2D in collisions:
		col.collision_layer = team
		col.collision_mask = 0
#endregion
