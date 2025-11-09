extends Label

@onready var main = $".."
@onready var onmain = $"../../.."

func _process(delta: float) -> void :
	if onmain.MenuMode == onmain.mode.setting:
		tran_text()
		task()
		
		if main.chooser == 0 and Global.settings.fullscreen:
			main.chooser = 1

func tran_text():
	if main.chooser == 0:
		if Global.settings.fullscreen:
			self.add_theme_color_override("font_color", Color8(120, 120, 120))
		else:
			self.add_theme_color_override("font_color", Color8(255, 255, 0))
	else:
		if Global.settings.fullscreen:
			self.add_theme_color_override("font_color", Color8(120, 120, 120))
		else:
			self.add_theme_color_override("font_color", Color8(255, 255, 255))

func task():
	if main.chooser == 0 and !Global.settings.fullscreen and !OS.get_name() == "Android":
		if Input.is_action_just_pressed("left"):
			Global.settings.windowsize -= 1
			Global.settings.config_window()
			Global.settings.save_settings()
		elif Input.is_action_just_pressed("right"):
			Global.settings.windowsize += 1
			Global.settings.config_window()
			Global.settings.save_settings()
