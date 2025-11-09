extends Label

@onready var main = $".."
@onready var onmain = $"../../.."
var check = ""

func _process(delta: float) -> void :
	if onmain.MenuMode == onmain.mode.setting:
		tran_text()
		task()
		
		if main.chooser == 1 and OS.get_name() == "Android":
			main.chooser = 2

func tran_text():
	if main.chooser == 1:
		if OS.get_name() == "Android":
			self.add_theme_color_override("font_color", Color8(120, 120, 120))
		else:
			self.add_theme_color_override("font_color", Color8(255, 255, 0))
	else:
		if OS.get_name() == "Android":
			self.add_theme_color_override("font_color", Color8(120, 120, 120))
		else:
			self.add_theme_color_override("font_color", Color8(255, 255, 255))

func task():
	if main.chooser == 1 and !OS.get_name() == "Android":
		if Input.is_action_just_pressed("left"):
			Global.settings.fullscreen = false
			Global.settings.save_settings()
			Global.settings.config_fullscreen()
		elif Input.is_action_just_pressed("right"):
			Global.settings.fullscreen = true
			Global.settings.save_settings()
			Global.settings.config_fullscreen()
