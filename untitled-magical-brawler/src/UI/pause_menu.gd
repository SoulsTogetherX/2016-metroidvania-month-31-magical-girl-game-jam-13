extends Control

func resume():
	get_tree().paused = false
	
func pause():
	get_tree().paused = true
	
