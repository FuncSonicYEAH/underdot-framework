extends Control

@onready var main = $"../.."
var choice: int = 0
var press: int = 0

func _process(delta: float) -> void:
	if main.MenuMode == main.mode.datamenu:
		Select()
		text_color()

func Select():
	if choice > 2: choice = 2
	elif choice < 0: choice = 0
	
	if Input.is_action_just_pressed("left"): choice -= 1
	elif Input.is_action_just_pressed("right"): choice += 1
	elif Input.is_action_just_pressed("up"): choice -= 2
	elif Input.is_action_just_pressed("down"): choice += 2
	
	if Input.is_action_just_pressed("enter"):
		press += 1
		if press > 1: 
			match choice:
				0:
					Sounds.intro.stop()
					get_tree().change_scene_to_file(Global.player.data1.save_room)
				2:
					main.MenuMode = main.mode.setting
	
func text_color():
	match choice:
		0:
			$Continue.add_theme_color_override("font_color", Color8(255, 255, 0))
			$Reset.add_theme_color_override("font_color", Color8(255, 255, 255))
			$Settings.add_theme_color_override("font_color", Color8(255, 255, 255))
		1:
			$Continue.add_theme_color_override("font_color", Color8(255, 255, 255))
			$Reset.add_theme_color_override("font_color", Color8(255, 255, 0))
			$Settings.add_theme_color_override("font_color", Color8(255, 255, 255))
		2:
			$Continue.add_theme_color_override("font_color", Color8(255, 255, 255))
			$Reset.add_theme_color_override("font_color", Color8(255, 255, 255))
			$Settings.add_theme_color_override("font_color", Color8(255, 255, 0))
