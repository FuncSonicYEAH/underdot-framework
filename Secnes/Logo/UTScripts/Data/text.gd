extends Control

func _ready() -> void:
	Global.player.data1.is_save_load()
	Global.player.data1.load_gamedata()

func _process(delta: float) -> void:
	$Name.text = Global.player.Name
	$Lv.text = "LV " + str(Global.player.lv)
	$Room.text = Global.player.data1.room_save_name
