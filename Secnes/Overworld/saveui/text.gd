extends Control

func _process(delta: float) -> void:
	SetText()
	Save()
	

func SetText():
	if Global.player.data1.is_save:
		$Name.text = Global.player.Name
		$Lv.text = "LV " + str(Global.player.lv)
		$Room.text = Global.player.data1.room_save_name
	else:
		$Name.text = "EMPTY"
		$Lv.text = "LV " + str(0)
		$Room.text = "--"
		
func Save():
	if $"..".mode == $"..".Mode.SAVING:
		$".".modulate = Color(255,255,0,1)
		$Save.visible = false
		$Return.visible = false
		$"../HeartOw".visible = false
		$Saved.visible = true
	else:
		$".".modulate = Color(255,255,255,1)
		$Save.visible = true
		$Return.visible = true
		$"../HeartOw".visible = true
		$Saved.visible = false
