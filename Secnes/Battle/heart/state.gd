extends CharacterBody2D

enum mode{none,red,blue}
var HeartMode = mode.red

@onready var redsoul = $red
@onready var bluesoul = $blue

func _ready() -> void:
	z_index = Global.index.player

func _process(delta: float) -> void:
	if Global.state.BattleState == Global.state.Battle.MENU:
		HeartMode = mode.none
		
func _physics_process(delta):
	move_and_slide()

func hurt():
	Global.player.hp -= 1
