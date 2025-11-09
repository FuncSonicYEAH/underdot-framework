extends Control

@onready var main = $".."

func _ready() -> void :
	pass


func _process(delta: float) -> void :
	nodemode()

func nodemode():
	if main.MenuMode == main.mode.intro:
		visible = true
	else:
		visible = false
