extends CanvasLayer

func _process(delta: float) -> void :
	$Main / Hp.position.x = 6 + Global.player.maxhp
	$Main / HpNumber.position.x = 28 + Global.player.maxhp * 1.2
	$Main / HpBottom.scale = Vector2(Global.player.maxhp * 1.2, 20)
	$Main / HpTop.scale = Vector2(Global.player.hp * 1.2, 20)
	$Main / HpNumber.text = str(int(Global.player.hp)) + " / " + str(Global.player.maxhp)
