@tool
class_name AbilityUIDisplay extends PaddingContainer


#region Private Variables
var _fade_tween : Tween
#endregion


#region OnReady Variables
@onready var _ability_name: Label = %Name
@onready var _icon: TextureRect = %Icon
@onready var _description: Label = %Description
#endregion



#region Virtual Methods
func _ready() -> void:
	if !Engine.is_editor_hint():
		_force_fade(false)
	_update_info(null)
#endregion


#region Private Methods
func _update_info(ability : AbilityData) -> void:
	if !ability:
		_ability_name.text = "Template Name"
		_icon.texture = null
		_description.text = "Template Description"
		return
	
	_ability_name.text = ability.get_ability_name()
	_icon.texture = ability.get_icon()
	_description.text = ability.get_description()

func _show_tween(
	fade_in : float = 0.5, delay : float = 2.0,
	fade_out : float = 0.5
) -> void:
	if _fade_tween:
		_fade_tween.kill()
	
	_fade_tween = create_tween()
	_fade_tween.tween_property(
		self, "modulate:a",
		1.0, fade_in
	)
	_fade_tween.tween_interval(delay)
	_fade_tween.tween_property(
		self, "modulate:a",
		0.0, fade_out
	)
func _force_fade(toggle : bool) -> void:
	modulate.a = float(toggle)
#endregion


#region Public Methods
func display_ability(ability : AbilityData) -> void:
	_update_info(ability)
	_show_tween()
#endregion
