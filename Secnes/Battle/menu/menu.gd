extends Node2D

var choice = 0
@onready var main = $".."
@onready var heart = %Heart

func _ready() -> void:
	z_index = Global.index.button

func _process(delta: float) -> void:
	if Global.state.BattleState != Global.state.Battle.ENEMYTRUN and main.menu_mode == main.menu.none:
		select()
		heart_position()
		reruslt()

func select():
	if choice > 3:
		choice = 0
	if choice < 0:
		choice = 3
	
	if Input.is_action_just_pressed("left"):
		choice -= 1
	elif Input.is_action_just_pressed("right"):
		choice += 1

func heart_position():
	match choice:
		0:
			heart.position = Vector2(49,452)
		1:
			heart.position = Vector2(203,452)
		2:
			heart.position = Vector2(362,452)
		3:
			heart.position = Vector2(516,452)
			
func reruslt():
	if Input.is_action_just_pressed("enter"):
		match choice:
			0:
				main.menu_mode = main.menu.fight
			1:
				main.menu_mode = main.menu.act
