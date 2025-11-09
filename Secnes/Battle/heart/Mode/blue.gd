extends Node

@onready var main = $".."
@onready var heart_sprite = $"../Heart"

enum BlueDir { LEFT, RIGHT, UP, DOWN }

const SPEED := 180.0
const JUMP_FORCE := 400.0
const FRICTION := 120.0  # 减速系数（像素/秒²）

var blue_heart_direction := BlueDir.DOWN
var i = 0

func _physics_process(delta: float) -> void:
	if main.HeartMode != main.mode.blue:
		return

	heart_sprite.modulate = Color(0, 0, 1, 1)  # 蓝色
	_update_direction()
	_handle_movement(delta)
	set_direction()

# 更新精灵朝向
func _update_direction() -> void:
	match blue_heart_direction:
		BlueDir.DOWN:
			heart_sprite.frame = 0
			heart_sprite.flip_v = false
			heart_sprite.flip_h = false
		BlueDir.UP:
			heart_sprite.frame = 0
			heart_sprite.flip_v = true
			heart_sprite.flip_h = false
		BlueDir.LEFT:
			heart_sprite.frame = 1
			heart_sprite.flip_v = false
			heart_sprite.flip_h = false
		BlueDir.RIGHT:
			heart_sprite.frame = 1
			heart_sprite.flip_v = false
			heart_sprite.flip_h = true

# 处理移动和跳跃
func _handle_movement(delta: float) -> void:
	var gravity = main.get_gravity()  # Vector2(0, 980) 默认

	# 应用重力（根据当前方向）
	match blue_heart_direction:
		BlueDir.DOWN:
			main.velocity.y += gravity.y * delta
		BlueDir.UP:
			main.velocity.y -= gravity.y * delta
		BlueDir.LEFT:
			main.velocity.x -= gravity.y * delta
		BlueDir.RIGHT:
			main.velocity.x += gravity.y * delta
	
	# 检测碰撞
	var can_jump := false
	match blue_heart_direction:
		BlueDir.DOWN:
			can_jump = main.is_on_floor()
		BlueDir.UP:
			can_jump = main.is_on_ceiling()
		BlueDir.LEFT, BlueDir.RIGHT:
			can_jump = main.is_on_wall()
	
	# 跳跃逻辑
	if can_jump:
		if Input.is_action_just_pressed("up") and blue_heart_direction == BlueDir.DOWN:
			main.velocity.y = -JUMP_FORCE
		elif Input.is_action_just_pressed("down") and blue_heart_direction == BlueDir.UP:
			main.velocity.y = JUMP_FORCE
		elif Input.is_action_just_pressed("right") and blue_heart_direction == BlueDir.LEFT:
			main.velocity.x = JUMP_FORCE
		elif Input.is_action_just_pressed("left") and blue_heart_direction == BlueDir.RIGHT:
			main.velocity.x = -JUMP_FORCE

	# 移动输入
	if blue_heart_direction == BlueDir.UP or blue_heart_direction == BlueDir.DOWN:
		var h_axis := Input.get_axis("left", "right")
		if h_axis:
			main.velocity.x = h_axis * SPEED
		else:
			main.velocity.x = move_toward(main.velocity.x, 0, SPEED)
	elif blue_heart_direction == BlueDir.LEFT or blue_heart_direction == BlueDir.RIGHT:
		var v_axis := Input.get_axis("up", "down")
		if v_axis:
			main.velocity.y = v_axis * SPEED
		else:
			main.velocity.y = move_toward(main.velocity.y, 0, SPEED)
			
func set_direction():
	if Input.is_action_just_pressed("ctrl"):
		i += 1
		if i > 3: i = 0
		
		Global.camera.ShakeScreen(15, 1)
		
		#var tween = create_tween()
		#tween.set_parallel(true)
		#
		#var original_pos = main.position
		#var pos = 0
		#var drop_pos = original_pos + Vector2(0, pos - 20)
		
		match i:
			0: 
				blue_heart_direction = BlueDir.DOWN
			1: 
				blue_heart_direction = BlueDir.UP
			2: 
				blue_heart_direction = BlueDir.LEFT
			3: 
				blue_heart_direction = BlueDir.RIGHT
