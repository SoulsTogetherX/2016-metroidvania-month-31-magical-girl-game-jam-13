@tool
class_name FPSDisplayLabel extends Label


#region Constants
const FONT_WIDTH := 60
#endregion


#region External Variables
func _init() -> void:
	top_level = true
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	add_theme_font_size_override("font_size", FONT_WIDTH)

func _process(_delta: float) -> void:
	text = "FPS: %s" % str(Engine.get_frames_per_second())
#endregion
