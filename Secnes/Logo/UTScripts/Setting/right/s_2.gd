extends Label

@onready var main = $"../../VBoxContainer"

func _process(delta: float) -> void:
	text = "< x"+ str(Global.settings.windowsize) +" >"
	
	tran_text()

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
