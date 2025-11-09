extends Node2D

@export_subgroup("Enemy Info")
@export var isactive = [false, false, false]
@export var enemy = ["","",""]
@export var maxhp = [0,0,0]
@export var hp = [0,0,0]
@export var can_spare = [false, false, false]

@export_subgroup("Enemy Action")
@export var act = [["","","","","",""],["","","","","",""],["","","","","",""]]
@export var actdialog = [["","","","","",""],["","","","","",""],["","","","","",""]]


func _ready() -> void:
	var perfix = "[font=res://Fonts/SANS-Spacing/SANS-Btdialog.tres][font_size=16]"
	$EnemyDialog._add_dialog(perfix + "Hello[speed=0.6]...[/speed]\nThis is a test[pause][clear]" + perfix + "Could you please edit me?[wait=2][end]")
