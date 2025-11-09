extends Node2D

enum mode{logo, intro, humanname, datamenu, setting}
var MenuMode = mode.logo

func _ready() -> void :
	Global.player.data1.load_gamedata()
	Fade.fade_config()
