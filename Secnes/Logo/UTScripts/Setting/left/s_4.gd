extends Label

@onready var main = $".."
@onready var onmain = $"../../.."

func _process(delta: float) -> void :
    if onmain.MenuMode == onmain.mode.setting:
        tran_text()
        text_from()

func text_from():
    text = "WINDOW SIZE" + "             " + "< x" + str(Global.windowsize) + " >"

func tran_text():
    if main.chooser == 2:
        self.add_theme_color_override("font_color", Color8(255, 255, 0))
    else:
        self.add_theme_color_override("font_color", Color8(255, 255, 255))
