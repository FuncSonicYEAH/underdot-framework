extends Control

@onready var main = $".."

func _process(delta: float) -> void :
	nodemode()
	exit()

func nodemode():
	if main.MenuMode == main.mode.setting:
		visible = true
	else:
		visible = false

func exit():
	if Input.is_action_just_pressed("shift"):
		$VBoxContainer.chooser = 0
		print(str(Global.player.data1.is_save))
		if Global.player.data1.is_save == true:
			main.MenuMode = main.mode.datamenu
		else:
			main.MenuMode = main.mode.intro
		Global.settings.save_settings()
