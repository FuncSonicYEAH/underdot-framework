extends Node2D

func _ready() -> void:
	Fade.fade_config()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		Fade.fade_config("fade_out", "res://Secnes/Logo/utmenu.tscn")
