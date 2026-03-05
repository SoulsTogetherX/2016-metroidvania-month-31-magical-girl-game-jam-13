@tool
class_name Player extends CombatEntity


#region Onready Variables
@onready var _ability_cache: AbilityCacheModule = %AbilityCacheModule
@onready var _camera_lead: CameraLead = $CameraLead
#endregion



#region Virtual Methods
func _ready() -> void:
	reset_camera_lead_direction()
	update_camera_lead_y()
#endregion


#region Ability Methods
func has_ability(ability : AbilityData) -> bool:
	if ability == null:
		return false
	return _ability_cache.has_ability(ability.get_ability_type())
func register_ability(ability : AbilityData) -> void:
	_ability_cache.register_ability(ability)
#endregion


#region Camera Lead Methods
func get_camera_lead() -> Marker2D:
	return _camera_lead

func reset_camera_lead_direction() -> void:
	if _camera_lead == null:
		return
	_camera_lead.direction = Vector2.ZERO
func set_camera_lead_direction(direction : Vector2) -> void:
	if _camera_lead == null:
		return
	_camera_lead.direction = direction
func update_camera_lead_y() -> void:
	if _camera_lead == null:
		return
	_camera_lead.y_pos = global_position.y


func set_camera_lead_x_bias(val : float) -> void:
	if _camera_lead == null:
		return
	_camera_lead.set_x_bias(val)
func set_camera_lead_y_bias(val : float) -> void:
	if _camera_lead == null:
		return
	_camera_lead.set_y_bias(val)
func set_camera_flat_y_offset(val : float) -> void:
	if _camera_lead == null:
		return
	_camera_lead.set_flat_y_offset(val)

func force_current_offset() -> void:
	if _camera_lead == null:
		return
	_camera_lead.force_current_offset()
#endregion
