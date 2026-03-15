@tool
extends PhantomCameraNoiseEmitter2D


#region Virtual Methods
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	noise_emitter_layer = (
		1 if SettingsHolder.screenshake else 0
	)
#endregion
