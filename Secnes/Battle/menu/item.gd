extends AnimatedSprite2D

@onready var main = $".."

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Global.state.BattleState == Global.state.Battle.MENU:
		if main.choice == 2:
			frame = 1
		else:
			frame = 0
