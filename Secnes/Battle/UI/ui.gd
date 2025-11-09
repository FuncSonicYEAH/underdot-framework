extends Node2D
@onready var player = %Player

func _ready():
	z_index = Global.index.ui

func _process(delta):
	$Name.text = Global.player.Name + "   LV " + str(Global.player.lv)
	$Hp.text = str(Global.player.hp) + " / " + str(Global.player.maxhp)
	
	$Hp.position = Vector2(292 + Global.player.maxhp * 1.2, 399)
	
	$BottomHp.scale = Vector2(Global.player.maxhp * 1.2, 20)
	$TopHp.scale = Vector2(Global.player.hp * 1.2, 20)
