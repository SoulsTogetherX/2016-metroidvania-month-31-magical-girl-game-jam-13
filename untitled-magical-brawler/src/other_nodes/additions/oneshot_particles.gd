class_name OneshotParticles extends CPUParticles2D


func start_final_emit(parent : Node) -> void:
	one_shot = true
	emitting = true
	if get_parent() == null:
		parent.add_child(self)
	else:
		reparent(parent)
	
	finished.connect(queue_free)
