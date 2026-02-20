class_name AssignPlayer extends Node

@export var property_name : StringName

func _ready() -> void:
	get_parent().set(property_name, Global.player)
