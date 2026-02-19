extends Control

func _ready():
	set_paused(true)

func _process(_delta):
	test_esc()

func set_paused(value : bool):
	if(get_tree().paused != value):
		get_tree().paused = value
		
		
func test_esc():
	if Input.is_action_just_pressed("escape") and get_tree().paused:
		set_paused(true)
	elif Input.is_action_just_pressed("escape") and !get_tree().paused:
		set_paused(false)


#region on buttons pressed
func _on_resume_game_btn_pressed() -> void:
	set_paused(false)


func _on_main_menu_btn_pressed() -> void:
	pass # Replace with function body.


func _on_quit_game_btn_pressed() -> void:
	get_tree().quit()
#endregion
