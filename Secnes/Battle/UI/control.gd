extends Control

func _process(delta: float) -> void:
	z_index = Global.index.dialog
	$Typer.position = Vector2(%Arena.position.x - %Arena.left - 5 + 26,
	 %Arena.position.y - %Arena.up - 5 + 17)
	$Fight.position = Vector2(%Arena.position.x - %Arena.left - 5 + 26,
	 %Arena.position.y - %Arena.up - 5 + 17)
