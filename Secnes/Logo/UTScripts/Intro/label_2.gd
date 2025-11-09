extends Label

@onready var main = $".."
@onready var onmain = $"../../.."

func _process(delta: float) -> void :
	tran_text()
	press_enter()

func tran_text():
	if main.chooser == 1:
		self.add_theme_color_override("font_color", Color8(255, 255, 0))
	else:
		self.add_theme_color_override("font_color", Color8(255, 255, 255))

func press_enter():
	if Input.is_action_just_pressed("enter") and onmain.MenuMode == onmain.mode.intro and main.chooser == 1:
		onmain.MenuMode = onmain.mode.setting
