extends Control
@onready var main = $"../.."

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Global.state.BattleState == Global.state.Battle.MENU and main.menu_mode == main.menu.fight:
		visible = true
	else:
		visible = false
