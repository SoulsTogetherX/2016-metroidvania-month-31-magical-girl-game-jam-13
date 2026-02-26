@tool
class_name EditorUtilities extends Object


#region Confirm Child
static func confirmed_child(
	parent : Node,
	property_name : StringName,
	child_name : String,
	create_node_method : Callable,
	settup_node_method : Callable,
	idx : int = -1
) -> void:
	if !parent:
		return
	
	var child := parent.get_node_or_null(child_name)
	if child == null:
		child = create_node_method.call()
		parent.add_child(child)
		
		child.owner = parent.owner
		child.name = child_name
	settup_node_method.call(child)
	
	if idx >= 0:
		parent.move_child.call_deferred(child, idx)
	
	child.tree_exited.connect(
		EditorUtilities.confirmed_child.bind(
			parent, property_name, child_name,
			create_node_method, settup_node_method, idx
		),
		CONNECT_ONE_SHOT
	)
	
	if !property_name.is_empty():
		parent.set(property_name, child)
#endregion
