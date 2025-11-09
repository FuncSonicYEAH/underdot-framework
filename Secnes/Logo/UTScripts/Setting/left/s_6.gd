extends Label

@onready var main = $".."
@onready var onmain = $"../../.."

var lang_text: String = ""
var chooser: int = 0

# 可用语言列表，顺序决定切换顺序


func _process(delta: float) -> void:
	if onmain.MenuMode == onmain.mode.setting:
		tran_text()

func text_from():
	text = "               " + tr("setting_lang") + "< " + lang_text + " >"

func tran_text():
	if main.chooser == 2:
		self.add_theme_color_override("font_color", Color8(255, 255, 0))
	else:
		self.add_theme_color_override("font_color", Color8(255, 255, 255))
