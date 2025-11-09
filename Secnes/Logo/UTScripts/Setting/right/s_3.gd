extends Label

@onready var main = $"../../VBoxContainer"

func _process(delta: float) -> void:
	var _str: String
	if Global.settings.fullscreen: _str = tr("setting_true")
	else: _str = tr("setting_false")
	
	text = "< "+ _str +" >"
	
	tran_text()

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
