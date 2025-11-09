extends Control

@onready var main = $".."

func _ready() -> void :
	$AnimationPlayer.play("d1")


func _process(delta: float) -> void :
	Global.player.data1.load_gamedata()
	nodemode()
	pressenter()

func nodemode():
	if main.MenuMode == main.mode.logo:
		visible = true
	else:
		visible = false

func pressenter():
	if Input.is_action_just_pressed("enter") and main.MenuMode == main.mode.logo:
		if Global.player.data1.is_save:
			main.MenuMode = main.mode.datamenu
		else:
			main.MenuMode = main.mode.intro
