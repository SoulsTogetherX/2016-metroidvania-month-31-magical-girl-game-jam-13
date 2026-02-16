extends Control


func _ready():
	$AnimationPlayer.play("RESET")
	

func _process(_delta):
	test_esc()


func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	
	
func test_esc():
	if Input.is_action_just_pressed("escape") and get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("escape") and !get_tree().paused:
		resume()


#region on buttons pressed
func _on_resume_game_btn_pressed() -> void:
	resume()


func _on_main_menu_btn_pressed() -> void:
	pass # Replace with function body.


func _on_quit_game_btn_pressed() -> void:
	get_tree().quit()
#endregion
