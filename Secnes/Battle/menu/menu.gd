extends Node2D

var choice = 0
@onready var heart = %Heart

func _ready() -> void:
	z_index = Global.index.button

func _process(delta: float) -> void:
	if Global.state.BattleState != Global.state.Battle.ENEMYTRUN:
		select()
		heart_position()

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
