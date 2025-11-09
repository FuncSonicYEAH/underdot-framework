extends Label

@onready var main = $".."
@onready var onmain = $"../../.."

var press: int = 0

func _process(delta: float) -> void :
	tran_text()
	press_enter()

func tran_text():
	if main.chooser == 0:
		self.add_theme_color_override("font_color", Color8(255, 255, 0))
	else:
		self.add_theme_color_override("font_color", Color8(255, 255, 255))

func press_enter():
	if Input.is_action_just_pressed("enter") and onmain.MenuMode == onmain.mode.intro and main.chooser == 0:
		press += 1
		if press > 1: Fade.fade_config("fade_out", "res://Secnes/Overworld/overworldtest.tscn")
