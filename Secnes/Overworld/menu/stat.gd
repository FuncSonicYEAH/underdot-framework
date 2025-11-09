extends Control
@onready var main = $"../.."


func _process(delta: float) -> void:
	if main.menumode == main.Mode.stat:
		exit()



func exit():
	if Input.is_action_just_pressed("shift"):
			main.menumode = main.Mode.none
