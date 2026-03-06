class_name AssignCameraLead extends Node



#region External Variables
@export_group("Settings")
@export_subgroup("Bias")
@export var x_bais : float = Constants.DEFAULT_X_BAIS
@export var y_bias : float = Constants.DEFAULT_Y_BAIS

@export_subgroup("Y Positioning")
@export var flat_y_offset : float = Constants.DEFAULT_FLAT_Y_OFFSET

@export_subgroup("Other")
@export var force_offset : bool = false
#endregion



#region Virtual Methods
func _ready() -> void:
	var phantom : PhantomCamera2D = get_parent()
	phantom.became_active.connect(_on_active)
	phantom.became_inactive.connect(_on_inactive)
#endregion


#region Private Methods (On Signal)
func _on_active() -> void:
	var player := Global.player
	player.set_camera_lead_x_bias(x_bais)
	player.set_camera_lead_y_bias(y_bias)
	player.set_camera_flat_y_offset(flat_y_offset)
	
	if force_offset:
		Global.player.force_current_offset()
func _on_inactive() -> void:
	var player := Global.player
	player.set_camera_lead_x_bias(Constants.DEFAULT_X_BAIS)
	player.set_camera_lead_y_bias(Constants.DEFAULT_Y_BAIS)
	player.set_camera_flat_y_offset(Constants.DEFAULT_FLAT_Y_OFFSET)
#endregion
