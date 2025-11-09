extends Node2D

@onready var main = $".."
@onready var stat = $stat

func _process(delta: float) -> void:
	from()
	
func from():
	match main.menumode:
		main.Mode.none:
			stat.visible = false
		main.Mode.stat:
			stat.visible = true
