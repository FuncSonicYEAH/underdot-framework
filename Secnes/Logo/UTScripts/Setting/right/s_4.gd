extends Label

@onready var main = $"../../VBoxContainer"

const LANGUAGES = ["en", "zh_CN"]
const LANGUAGE_NAMES = {
	"en": "ENGLISH",
	"zh_CN": "简体中文"
}

var lang_text: String

func _process(delta: float) -> void:
	_text_for()
	tran_text()
	task()
	
	text = "< " + lang_text + " >"

func _text_for():
	if LANGUAGE_NAMES.has(Global.settings.language):
		lang_text = LANGUAGE_NAMES[Global.settings.language]
	else:
		lang_text = "Unknown"
		
func task():
	if main.chooser != 2:
		return

	var current_index = LANGUAGES.find(Global.settings.language)
	if current_index == -1:
		current_index = 0

	var new_index = current_index

	if Input.is_action_just_pressed("right"):
		new_index = wrapi(current_index + 1, 0, LANGUAGES.size())
	elif Input.is_action_just_pressed("left"):
		new_index = wrapi(current_index - 1, 0, LANGUAGES.size())

	if new_index != current_index:
		Global.settings.language = LANGUAGES[new_index]
		TranslationServer.set_locale(Global.settings.language)

func tran_text():
	if main.chooser == 2:
		self.add_theme_color_override("font_color", Color8(255, 255, 0))
	else:
		self.add_theme_color_override("font_color", Color8(255, 255, 255))
