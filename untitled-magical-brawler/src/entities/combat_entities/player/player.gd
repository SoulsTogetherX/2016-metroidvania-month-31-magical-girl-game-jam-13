@tool
class_name Player extends CombatEntity


#region Onready Variables
@onready var _ability_cache: AbilityCacheModule = %AbilityCacheModule
@onready var _camera_lead: CameraLead = $CameraLead
#endregion



#region Virtual Methods
func _ready() -> void:
	reset_camera_lead_offset()
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

func reset_camera_lead_offset() -> void:
	if _camera_lead == null:
		return
	_camera_lead.offset = Vector2.ZERO
func set_camera_lead_offset(offset : Vector2) -> void:
	if _camera_lead == null:
		return
	_camera_lead.offset = offset
func update_camera_lead_y() -> void:
	if _camera_lead == null:
		return
	_camera_lead.y_pos = global_position.y
#endregion
