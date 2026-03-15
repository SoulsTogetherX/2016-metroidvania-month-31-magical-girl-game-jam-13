class_name Trail extends Line2D


#region External Variables
@export var root_path : Node2D

@export var max_points := 200
@export var tick_rate := 2
#endregion


#region Private Variables
var _current_tick : int = 1
#endregion


#region OnReady Variables
@onready var curve := Curve2D.new()
#endregion



#region Virtual Methods
func _ready() -> void:
	top_level = true
	
	if root_path == null:
		if owner == null:
			root_path = self
			return
		root_path = owner
		return

func _physics_process(_delta: float) -> void:
	_on_tick()
#endregion


#region Private Methods
func _on_tick() -> void:
	if _current_tick >= tick_rate:
		_current_tick = 1
		
		curve.add_point(
			to_local(root_path.global_position)
		)
		
		if curve.get_baked_points().size() > max_points:
			curve.remove_point(0)
		points = curve.get_baked_points()
		
		return
	_current_tick += 1
#endregion
