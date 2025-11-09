extends Node

var Name = "PLAYER"
var lv = 1
var hp = 20
var maxhp = 20
var atk = 10
var def = 10
var expl = 0
var target_exp = 10
var gold = 0
var weapon = null
var armor = null
var weapon_atk = 0
var armor_def = 0
var items = ["", "", "", "", "", "", "", ""]
var save_room: String = "res://Room/Overworld/OverWorldTest.tscn"
var room_name: String = ""
var room_save_name: String = ""

var player_pos_screen = Vector2(0, 0)
var save_position = Vector2(0,0)

@onready var data1 = $Gamedata1
@onready var data2 = $Gamedata2
@onready var data3 = $Gamedata3
