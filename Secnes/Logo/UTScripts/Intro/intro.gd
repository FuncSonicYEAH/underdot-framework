extends Control

@onready var main = $".."
var has_run := false

func _process(delta: float) -> void :
	nodemode()
	if main.MenuMode == main.mode.intro:
		if not has_run:
			Sounds.intro.play()
			has_run = true  # 标记为已运行

func nodemode():
	if main.MenuMode == main.mode.intro:
		visible = true
	else:
		visible = false
