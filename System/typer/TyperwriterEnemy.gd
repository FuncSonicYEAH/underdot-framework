extends Node

@onready var typer = $Typer
@onready var bullue = $Rightwide

var perfix = "[color=#000000]"

func _ready() -> void:
	$Typer.visible = false
	$Rightwide.visible = false
	$Typer.add_theme_color_override("default_color", Color8(0, 0, 0))
	typer.emit_signal("typing_end")
	
func _add_dialog(text):
	typer.start_typing(perfix+text)

func _on_typer_typing_end() -> void:
	$Rightwide.visible = false
	$Typer.visible = false

func _on_typer_typing_start() -> void:
	$Rightwide.visible = true
	$Typer.visible = true
