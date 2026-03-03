@tool
extends PaddingContainer


#region External Variables
@export_group("Health")
@export var health_compoent : HealthComponent:
	set(val):
		if val == health_compoent:
			return
		
		if health_compoent:
			health_compoent.max_health_changed.disconnect(_update_background)
			health_compoent.health_changed.disconnect(_update_hearts)
		health_compoent = val
		if health_compoent:
			health_compoent.max_health_changed.connect(_update_background)
			health_compoent.health_changed.connect(_update_hearts)
			
			if is_node_ready():
				_update_background(health_compoent.max_health)
				_update_hearts(health_compoent.health)

@export_group("Settings")
@export var heart_scale : float = 0.8
#endregion


#region Private Variables
var _texture_size : Vector2
#endregion


#region OnReady
@onready var _background : TextureRect = %BackgroundHearts
@onready var _hearts : TextureRect = %Hearts
#endregion



#region Virtual Methods
func _ready() -> void:
	_background.scale = Vector2.ONE * heart_scale
	_hearts.scale = Vector2.ONE * heart_scale
	
	_texture_size = _background.texture.get_size()
	
	if health_compoent:
		_update_background(health_compoent.max_health)
		_update_hearts(health_compoent.health)
#endregion


#region Private Methods
func _update_background(val : int) -> void:
	if !is_node_ready():
		return
	
	_background.size = _texture_size * Vector2(val, 1)
	_hearts.size = _texture_size * Vector2(health_compoent.health, 1)
func _update_hearts(val : int) -> void:
	if !is_node_ready():
		return
	
	_hearts.size = _texture_size * Vector2(val, 1)
#endregion
