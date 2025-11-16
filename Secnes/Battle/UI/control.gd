extends Control
@onready var main = $".."

func _process(delta: float) -> void:
	z_index = Global.index.dialog
	$Typer.position = Vector2(%Arena.position.x - %Arena.left - 5 + 26,
	 %Arena.position.y - %Arena.up - 5 + 17)
	$Fight.position = Vector2(%Arena.position.x - %Arena.left - 5 + 26,
	 %Arena.position.y - %Arena.up - 5 + 17)
	
	if main.menu_mode != main.menu.none:
		$Typer.visible = false
	else:
		$Typer.visible = true
