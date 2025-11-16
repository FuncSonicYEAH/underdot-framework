extends Node2D

@export var ename: String = "Enemy"
var hp: int = 0
@export var max_hp: int = 10
@export var can_spare: bool = false

@export var acts: Array[String] = ["","","","","",""]
@export var act_dialogs: Array[String] = ["","","","","",""]

func _ready() -> void:
	hp = max_hp

func get_display_name() -> String:
	return ename if ename else ""

func get_display_acts(enemy: int) -> String:
	return "* " + acts[enemy] if acts[enemy] else ""

func get_status() -> Dictionary:
	return {
		"name": ename,
		"hp": hp,
		"max_hp": max_hp,
		"can_spare": can_spare,
		"acts": acts.duplicate(),
		"act_dialogs": act_dialogs.duplicate()
	}
