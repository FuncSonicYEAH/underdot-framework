extends Control
@onready var main = $"../.."
enum state {enemy,eact}

var emode = state.enemy
var choice = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Global.state.BattleState == Global.state.Battle.MENU and main.menu_mode == main.menu.act:
		visible = true
	else:
		visible = false
