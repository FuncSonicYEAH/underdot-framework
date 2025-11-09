extends Label

func _process(delta: float) -> void:
	text = "LV " + str(Global.player.lv) + "\nHP " + str(Global.player.hp) + "/" + str(Global.player.maxhp) + "\nG " + str(Global.player.gold)
