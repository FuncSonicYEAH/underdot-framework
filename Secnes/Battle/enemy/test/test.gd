extends "res://Secnes/Battle/enemy/enemy.gd"

func _ready():
	ename = "Sans"
	max_hp = 20
	hp = max_hp
	can_spare = true
	acts = ["Check","Talk","","","",""]
	act_dialogs = ["",""]
	
