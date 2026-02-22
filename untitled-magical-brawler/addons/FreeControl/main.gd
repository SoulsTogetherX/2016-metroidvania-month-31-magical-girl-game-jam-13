# Made by Xavier Alvarez. A part of the "FreeControl" Godot addon.
@tool
extends EditorPlugin

const ICON_FOLDER := "res://addons/FreeControl/assets/icons/CustomType/"

func _enter_tree() -> void:
	# AutoSizeLabels
		# AutoSizeLabel
	add_custom_type(
		"AutoSizeLabel",
		"Label",
		load("uid://v0ehje2clt8q"),
		load(ICON_FOLDER + "AutoSizeLabel.svg")
	)
	
	# Buttons
		# Base
	add_custom_type(
		"AnimatedSwitch",
		"BaseButton",
		load("uid://ba40c75ghd5jn"),
		load(ICON_FOLDER + "AnimatedSwitch.svg")
	)
	add_custom_type(
		"HoldButton",
		"Control",
		load("uid://cxpavl8t4pjda"),
		load(ICON_FOLDER + "HoldButton.svg")
	)
			# MotionCheck
	add_custom_type(
		"BoundsCheck",
		"Control",
		load("uid://bmarfghi5ygvt"),
		load(ICON_FOLDER + "BoundsCheck.svg")
	)
	add_custom_type(
		"DistanceCheck",
		"Control",
		load("uid://dxfjq3ihql3b8"),
		load(ICON_FOLDER + "DistanceCheck.svg")
	)
	add_custom_type(
		"MotionCheck",
		"Control",
		load("uid://dalcaavf4vj2w"),
		load(ICON_FOLDER + "MotionCheck.svg")
	)
	
		# Complex
	add_custom_type(
		"ModulateTransitionButton",
		"Container",
		load("uid://cbavvc7w51o1e"),
		load(ICON_FOLDER + "ModulateTransitionButton.svg")
	)
	add_custom_type(
		"StyleTransitionButton",
		"Container",
		load("uid://8jyk6thl41yx"),
		load(ICON_FOLDER + "StyleTransitionButton.svg")
	)
	
	# PaddingContainer
	add_custom_type(
		"PaddingContainer",
		"Container",
		load("uid://dube6kmp8e6dk"),
		load(ICON_FOLDER + "PaddingContainer.svg")
	)
	
	# SizeControllers
		# MaxSizeContainer
	add_custom_type(
		"MaxSizeContainer",
		"Container",
		load("uid://qyynh24u37dl"),
		load(ICON_FOLDER + "MaxSizeContainer.svg")
	)
		# MaxRatioContainer
	add_custom_type(
		"MaxRatioContainer",
		"Container",
		load("uid://dxat85kl81ij8"),
		load(ICON_FOLDER + "MaxRatioContainer.svg")
	)
	
	# TransitionContainers
	add_custom_type(
		"ModulateTransitionContainer",
		"Container",
		load("uid://pgglabrqqqf8"),
		load(ICON_FOLDER + "ModulateTransitionContainer.svg")
	)
	add_custom_type(
		"StyleTransitionContainer",
		"Container",
		load("uid://dpxv0jw7hjhta"),
		load(ICON_FOLDER + "StyleTransitionContainer.svg")
	)
	add_custom_type(
		"StyleTransitionPanel",
		"Panel",
		load("uid://b1byk6qaj6eg4"),
		load(ICON_FOLDER + "StyleTransitionPanel.svg")
	)

func _exit_tree() -> void:
	# AutoSizeLabel
	remove_custom_type("AutoSizeLabel")
	
	# Buttons
		# Base
	remove_custom_type("AnimatedSwitch")
	remove_custom_type("HoldButton")
			# MotionCheck
	remove_custom_type("BoundsCheck")
	remove_custom_type("DistanceCheck")
	remove_custom_type("MotionCheck")
	
		# Complex
	remove_custom_type("ModulateTransitionButton")
	remove_custom_type("StyleTransitionButton")
	
	# PaddingContainer
	remove_custom_type("PaddingContainer")
	
	# SizeControllers
	remove_custom_type("MaxSizeContainer")
	remove_custom_type("MaxRatioContainer")
	
	# TransitionContainers
	remove_custom_type("ModulateTransitionContainer")
	remove_custom_type("StyleTransitionContainer")
	remove_custom_type("StyleTransitionPanel")
