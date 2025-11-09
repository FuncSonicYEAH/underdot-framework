extends Node

var fullscreen: bool = false
var windowsize: float = 1
var bgmvol = 1
var sfxvol = 1
var debug = true
var language = "zh_CN"

var winsize = Vector2(640, 480)

func _ready() -> void :
	var file = ConfigFile.new()
	var err = file.load("user://Settings.cfg")
	if err != OK:
		save_settings()
	
	load_settings()
	config_window()
	config_fullscreen()

func _process(delta: float) -> void :
	config_lang()
	
	if Input.is_action_just_pressed("fullscreen"):
		fullscreen = not fullscreen
		config_fullscreen()

func config_fullscreen():
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2(winsize.x * windowsize, winsize.y * windowsize))

func config_window():
	if windowsize > 2:
		windowsize = 2
	elif windowsize < 1:
		windowsize = 1

	var window = get_window()
	var new_size = Vector2i((winsize * windowsize).round())
	window.set_position(window.get_position() + (window.size - new_size) / 2)
	window.set_size(new_size)
	
func save_settings():
	var file = ConfigFile.new()

	file.set_value("window", "size", windowsize)
	file.set_value("window", "fullscreen", fullscreen)
	
	file.set_value("general","lang",language)

	file.save("user://Settings.cfg")

func load_settings():
	var file = ConfigFile.new()
	var err = file.load("user://Settings.cfg")
	if err != OK:
		return false

	if file.has_section_key("window", "size"):
		windowsize = file.get_value("window", "size")
	if file.has_section_key("window", "fullscreen"):
		fullscreen = file.get_value("window", "fullscreen")
	if file.has_section_key("general","lang"):
		language = file.get_value("general","lang")
		
func config_lang():
	TranslationServer.set_locale(language)
