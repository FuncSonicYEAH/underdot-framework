extends Control

@onready var main = $".."
var mode = "inputing"

func _process(delta: float) -> void :
	nodemode()
	exit()

func nodemode():
	if main.MenuMode == main.mode.humanname:
		visible = true
	else:
		visible = false

func exit():
	if Input.is_action_just_pressed("shift") and main.MenuMode == main.mode.humanname:
		main.MenuMode = main.mode.intro
