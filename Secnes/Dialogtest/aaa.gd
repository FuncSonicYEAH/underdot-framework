extends Node2D

var example_text = "[canskip=yes][face=susie/susie_0.png]* 又又又，这不是人类吗
[rainbow freq=1.0 sat=0.8 val=0.8 speed=1.0][shake rate=20 level=20][speed=0.04]  几天不见这么拉了[wait=1]，真的[/shake][/rainbow][pause][clear][/face]* 人类，我爱了你的木青\n  再见了，啊啊啊啊啊啊啊啊啊\n  你就是个鸡巴[pause][end]"

func New(text,pos: Vector2 = Vector2(0,0)):
	var _preload = preload("res://System/typer/Typerwriter.tscn")
	var _dialog = _preload.instantiate()
	_dialog.position = pos
	_dialog.dtext = text
	add_child(_dialog)
	return _dialog

func _ready() -> void:
	Fade.fade_config()
	New(example_text,Vector2(320, 392))
