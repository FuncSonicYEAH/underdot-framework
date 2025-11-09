extends Label

func _process(delta: float) -> void:
	text = "\"" + Global.player.Name + "\"\n\n" + "LV " + str(Global.player.lv) + "\nHP " + str(Global.player.hp) + "/" + str(Global.player.maxhp)
