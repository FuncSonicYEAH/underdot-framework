extends Node2D

func New(text):
	var _preload = preload("res://System/typer/Typerwriter.tscn")
	var _dialog = _preload.instantiate()
	if Global.player.player_pos_screen.y > 240:
		_dialog.position = Vector2(320, 90)
	elif Global.player.player_pos_screen.y <= 240:
		_dialog.position = Vector2(320, 396)
	_dialog.dtext = text
	add_child(_dialog)
	return _dialog
