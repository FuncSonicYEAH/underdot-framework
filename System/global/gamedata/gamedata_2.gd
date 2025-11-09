extends Node

const SAVE_SECTION = "data2"  # ← 统一的 section 名

@onready var main = $".."

var is_save = false
var save_room = ""
var room_save_name = ""
var save_position = Vector2(0, 0)

func _ready() -> void:
	var file = ConfigFile.new()
	var err = file.load("user://Gamedata.cfg")
	if err != OK:
		save_gamedata()  # 首次运行时创建默认存档
	else:
		is_save_load()   # 加载 is_save 标志

func save_gamedata():
	var file = ConfigFile.new()
	file.load("user://Gamedata.cfg")  # 可选：加载已有数据再覆盖部分字段

	file.set_value(SAVE_SECTION, "is_save", is_save)  # 存档存在，设为 true
	file.set_value(SAVE_SECTION, "name", main.Name)
	file.set_value(SAVE_SECTION, "lv", main.lv)
	file.set_value(SAVE_SECTION, "hp", main.hp)
	file.set_value(SAVE_SECTION, "maxhp", main.maxhp)
	file.set_value(SAVE_SECTION, "exp", main.expl)
	file.set_value(SAVE_SECTION, "target_exp", main.target_exp)
	file.set_value(SAVE_SECTION, "gold", main.gold)
	file.set_value(SAVE_SECTION, "save_room", save_room)
	file.set_value(SAVE_SECTION, "room_save_name", room_save_name)
	file.set_value(SAVE_SECTION, "save_position", save_position)

	file.save("user://Gamedata.cfg")

func is_save_load():
	var file = ConfigFile.new()
	var err = file.load("user://Gamedata.cfg")
	if err != OK:
		is_save = false
		return

	# 从统一 section 读取 is_save
	is_save = file.get_value(SAVE_SECTION, "is_save", is_save)

func load_gamedata():
	var file = ConfigFile.new()
	var err = file.load("user://Gamedata.cfg")
	if err != OK:
		return

	# 全部从 SAVE_SECTION 读取
	main.Name = file.get_value(SAVE_SECTION, "name", main.Name)
	main.lv = file.get_value(SAVE_SECTION, "lv", main.lv)
	main.hp = file.get_value(SAVE_SECTION, "hp", main.hp)
	main.maxhp = file.get_value(SAVE_SECTION, "maxhp", main.maxhp)
	main.expl = file.get_value(SAVE_SECTION, "exp", main.expl)
	main.target_exp = file.get_value(SAVE_SECTION, "target_exp", main.target_exp)
	main.gold = file.get_value(SAVE_SECTION, "gold", main.gold)
	save_room = file.get_value(SAVE_SECTION, "save_room", save_room)
	room_save_name = file.get_value(SAVE_SECTION, "room_save_name", room_save_name)
	save_position = file.get_value(SAVE_SECTION, "save_position", save_position)
