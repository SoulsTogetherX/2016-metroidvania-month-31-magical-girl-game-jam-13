# Made by Xavier Alvarez. A part of the "FreeControl" Godot addon.
@tool
class_name ExtrudeContainer extends Container


#region External Variables
@export var minimum_size : bool = false:
	set(val):
		if minimum_size != val:
			minimum_size = val
			
			update_minimum_size()
			queue_sort()

@export var extrude_left : int = 0:
	set(val):
		if extrude_left == val:
			return
		
		extrude_left = val
		update_minimum_size()
		queue_sort()
@export var extrude_top : int = 0:
	set(val):
		if extrude_top == val:
			return
		
		extrude_top = val
		update_minimum_size()
		queue_sort()
@export var extrude_right : int = 0:
	set(val):
		if extrude_right == val:
			return
		
		extrude_right = val
		update_minimum_size()
		queue_sort()
@export var extrude_bottom : int = 0:
	set(val):
		if extrude_bottom == val:
			return
		
		extrude_bottom = val
		update_minimum_size()
		queue_sort()
#endregion



#region Private Virtual Methods
func _get_minimum_size() -> Vector2:
	if clip_contents:
		return Vector2.ZERO
	
	var min_size : Vector2
	for child : Node in get_children():
		if child is Control && child.is_visible_in_tree():
			min_size = min_size.max(child.get_combined_minimum_size())
	
	min_size = (min_size - Vector2(
		extrude_left + extrude_right,
		extrude_right + extrude_top
	)).maxf(0.0)
	
	
	return min_size

func _notification(what : int) -> void:
	match what:
		NOTIFICATION_READY, NOTIFICATION_SORT_CHILDREN:
			_sort_children()

func _get_allowed_size_flags_horizontal() -> PackedInt32Array:
	return [SIZE_SHRINK_BEGIN, SIZE_FILL, SIZE_SHRINK_CENTER, SIZE_SHRINK_END]
func _get_allowed_size_flags_vertical() -> PackedInt32Array:
	return [SIZE_SHRINK_BEGIN, SIZE_FILL, SIZE_SHRINK_CENTER, SIZE_SHRINK_END]
#endregion


#region Private Methods
func _sort_children() -> void:
	var rect := get_extruded_rect()
	
	for child : Node in get_children():
		if child is Control && child.is_visible_in_tree():
			_sort_child(child, rect)
func _sort_child(child : Control, rect : Rect2) -> void:
	var min_size := child.get_combined_minimum_size()
	
	match child.size_flags_horizontal:
		SIZE_SHRINK_BEGIN:
			rect.size.x = min_size.x
		SIZE_SHRINK_CENTER:
			rect.position.x += (rect.size.x - min_size.x) * 0.5
			rect.size.x = min_size.x
		SIZE_SHRINK_END:
			rect.position.x += (rect.size.x - min_size.x)
			rect.size.x = min_size.x
	
	match child.size_flags_vertical:
		SIZE_SHRINK_BEGIN:
			rect.size.y = min_size.y
		SIZE_SHRINK_CENTER:
			rect.position.y += (rect.size.y - min_size.y) * 0.5
			rect.size.y = min_size.y
		SIZE_SHRINK_END:
			rect.position.y += (rect.size.y - min_size.y)
			rect.size.y = min_size.y
	
	fit_child_in_rect(child, rect)
#endregion


#region Private Methods
## Returns the rect of the total area the children will fill after padding calculations.
func get_extruded_rect() -> Rect2:
	var ret_pos : Vector2
	var ret_size : Vector2
	
	ret_pos = Vector2(
		-extrude_left, -extrude_top
	)
	ret_size = Vector2(
		size.x + (extrude_right + extrude_left),
		size.y + (extrude_bottom + extrude_top)
	)
	
	return Rect2(ret_pos, ret_size)
#endregion

# Made by Xavier Alvarez. A part of the "FreeControl" Godot addon.
