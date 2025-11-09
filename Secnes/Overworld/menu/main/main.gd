extends Control
@onready var main = $".."
@onready var heart = $"../Heart"

const xp = 76
var choice = 0

func _process(delta: float) -> void:
	if Global.state.OverworldState != Global.state.OverWorld.MENU:
		return
	
	if main.menumode == main.Mode.none:
			select()
			heart_position()
			press()

func select():
	if choice > 2:
		choice = 2
	elif choice < 0:
		choice = 0
	
	if Input.is_action_just_pressed("up"):
		Sounds.choose.play()
		choice -= 1
	elif Input.is_action_just_pressed("down"):
		Sounds.choose.play()
		choice += 1

func heart_position():
	match choice:
		0:
			heart.position = Vector2(xp,208)
		1:
			heart.position = Vector2(xp,244)
		2:
			heart.position = Vector2(xp,280)
			
func press():
	if Input.is_action_just_pressed("enter"):
		match choice:
			0:
				pass
			1:
				main.menumode = main.Mode.stat
