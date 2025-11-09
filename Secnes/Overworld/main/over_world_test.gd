extends Node2D

func _ready() -> void:
	Global.player.room_name = "Test Room"
	if Global.player.data1.is_save:
		$CharacterBody2D.position = Global.player.data1.save_position
