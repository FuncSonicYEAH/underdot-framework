extends Node

@onready var main = $".."

const SPEED = 180.0


func _physics_process(delta: float) -> void:
	if main.HeartMode == main.mode.red:
		$"../Heart".modulate = Color(255,0,0,1)
		heart_physics()

func heart_physics():
	var directionX := Input.get_axis("left", "right")
	if directionX:
		main.velocity.x = directionX * SPEED
	else:
		main.velocity.x = move_toward(main.velocity.x, 0, SPEED)
		
	var directionY := Input.get_axis("up", "down")
	if directionY:
		main.velocity.y = directionY * SPEED
	else:
		main.velocity.y = move_toward(main.velocity.y, 0, SPEED)
	
	
