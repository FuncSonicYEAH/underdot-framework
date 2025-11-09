extends VBoxContainer

@onready var main = $"../.."
var chooser = 0

func _process(delta: float) -> void :
	if main.MenuMode == main.mode.setting:
		setting_input()

func setting_input():
	if Input.is_action_just_pressed("up"):
		chooser -= 1
	elif Input.is_action_just_pressed("down"):
		chooser += 1

	if chooser > 3:
		chooser = 3
	elif chooser < 0:
		chooser = 0
