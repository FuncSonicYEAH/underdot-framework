extends CharacterBody2D

# === 可配置参数 ===
@export var base_speed: float = 200.0
@export var sprint_speed: float = 300.0
@export var hurt_knockback_distance: float = 20.0
@export var hurt_knockback_duration: float = 0.1
@export var invincibility_duration: float = 1.3
@export var blink_interval: float = 0.1
@export var hurt_ui_cooldown: float = 3.0
@export var hp_bar_offset: Vector2 = Vector2(0, -34)
@export var screen_menu_split_y: float = 240.0  # 分割线 y，用于菜单上下自动判断

# === 内部状态 ===
var current_speed: float = 200.0
var player_direction: Vector2 = Vector2.DOWN
var touch_area: bool = false

var is_hurt_ui_visible: bool = false
var hurt_timer: float = 0.0

var is_invincible: bool = false
var invincibility_timer: float = 0.0
var blink_timer: float = 0.0
var is_visible: bool = true

var current_tween: Tween = null

enum AnimationState { IDLE, WALKING }
var current_animation_state: AnimationState = AnimationState.IDLE

# 缓存节点（避免每帧 $ 查找）
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hp_layer: Node2D = $HpLayer/Main
@onready var menu_node: Node = $MenuLayer/Menu

# 方向 → 动画名映射表（避免重复 if-elif）
const DIR_TO_ANIM := {
	Vector2.UP: "up",
	Vector2.DOWN: "down",
	Vector2.LEFT: "left",
	Vector2.RIGHT: "right"
}

func _ready() -> void:
	current_speed = base_speed
	update_animation()

func _physics_process(delta: float) -> void:
	# --- 状态管理 ---
	if Global.state.OverworldState == null:
		return # 防御性处理

	# 受伤 UI 显示计时
	if is_hurt_ui_visible:
		hurt_timer += delta
		if hurt_timer >= hurt_ui_cooldown:
			hide_hurt_ui()

	# 无敌与闪烁
	if is_invincible:
		invincibility_timer += delta
		blink_timer += delta
		if blink_timer >= blink_interval:
			blink_timer = 0.0
			is_visible = !is_visible
			animated_sprite.modulate.a = 0.3 if is_visible else 1.0

		if invincibility_timer >= invincibility_duration:
			end_invincibility()

	# 主逻辑
	if Global.state.OverworldState == Global.state.OverWorld.MOVING:
		Player_Move()
		move_and_slide()
		update_animation()
	else:
		play_animation("idle")
		current_animation_state = AnimationState.IDLE

	# 其他共用逻辑（独立于状态）
	update_ui_and_hp()

func update_ui_and_hp() -> void:
	if get_player_hp() > 1:
		update_screen_position()
		update_menu_direction()

	check_death()

# ========== hp ==========
func get_player_hp() -> int:
	return Global.player.hp if Global.player != null else 1

func set_player_hp(value: int) -> void:
	if Global.player != null:
		Global.player.hp = value

func get_player_screen_pos_ref() -> Vector2:
	return Global.player.player_pos_screen if Global.player != null else Vector2.ZERO

func set_player_screen_pos(value: Vector2) -> void:
	if Global.player != null:
		Global.player.player_pos_screen = value

func get_player_save_pos_ref() -> Vector2:
	return Global.player.save_position if Global.player != null else Vector2.ZERO

func set_player_save_pos(value: Vector2) -> void:
	if Global.player != null:
		Global.player.save_position = value

# ========== 移动与输入 ==========
func Player_Move() -> void:
	var sprinting := Input.is_action_pressed("shift")
	current_speed = sprint_speed if sprinting else base_speed

	var direction = Input.get_vector("left", "right", "up", "down")
	var was_moving = velocity.length() > 0.1

	if direction:
		velocity = direction * current_speed
		player_direction = direction.snapped(Vector2.ONE * 0.5).normalized()  # 精准四方向归一
		current_animation_state = AnimationState.WALKING
	else:
		velocity = velocity.move_toward(Vector2.ZERO, current_speed * get_physics_process_delta_time() * 20)
		if not was_moving:
			current_animation_state = AnimationState.IDLE

# ========== 动画系统 ==========
func update_animation() -> void:
	if current_animation_state == AnimationState.WALKING:
		play_animation("walk")
	else:
		play_animation("idle")

func play_animation(prefix: String) -> void:
	var suffix = DIR_TO_ANIM.get(player_direction, "down")
	var anim_name = prefix + "_" + suffix
	if animated_sprite.animation != anim_name:
		animated_sprite.play(anim_name)

# ========== 受伤与无敌 ==========
func player_hurt(damage: int, knockback: bool = true) -> void:
	if is_invincible or get_player_hp() <= 0:
		return
	
	Sounds.hit.play()
	
	set_player_hp(get_player_hp() - damage)
	show_hurt_ui()
	if knockback:
		apply_knockback()
	start_invincibility()

func apply_knockback() -> void:
	if current_tween and current_tween.is_valid():
		current_tween.kill()

	var offset = Vector2.ZERO
	match player_direction:
		Vector2.UP:    offset.y =  hurt_knockback_distance
		Vector2.DOWN:  offset.y = -hurt_knockback_distance
		Vector2.LEFT:  offset.x =  hurt_knockback_distance
		Vector2.RIGHT: offset.x = -hurt_knockback_distance

	current_tween = create_tween()
	current_tween.tween_property(self, "position", position + offset, hurt_knockback_duration) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func show_hurt_ui() -> void:
	is_hurt_ui_visible = true
	hurt_timer = 0.0

	current_tween = create_tween()
	current_tween.tween_property(hp_layer, "position", hp_layer.position + hp_bar_offset, 0.4) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func hide_hurt_ui() -> void:
	is_hurt_ui_visible = false

	current_tween = create_tween()
	current_tween.tween_property(hp_layer, "position", Vector2.ZERO, 0.4) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func start_invincibility() -> void:
	is_invincible = true
	invincibility_timer = 0.0
	blink_timer = 0.0
	is_visible = true
	animated_sprite.modulate.a = 1.0

func end_invincibility() -> void:
	is_invincible = false
	animated_sprite.modulate.a = 1.0  # 恢复正常透明度
	animated_sprite.visible = true    # 确保可见（防残留）

# ========== UI & 场景交互 ==========
func update_screen_position() -> void:
	var viewport = get_viewport()
	if viewport:
		var screen_pos = viewport.get_canvas_transform().basis_xform(global_position)
		set_player_screen_pos(screen_pos)

func update_menu_direction() -> void:
	var pos = get_player_screen_pos_ref()
	menu_node.dir = "down" if pos.y > screen_menu_split_y else "up"

func check_death() -> void:
	if get_player_hp() < 1:
		get_tree().change_scene_to_file("res://Room/Overworld/gameover ow/game_over.tscn")

# ========== 输入与区域 ==========
func _on_check_area_area_entered(area: Area2D) -> void:
	touch_area = true

func _on_check_area_area_exited(area: Area2D) -> void:
	touch_area = false

func InputConfirm() -> bool:
	return touch_area and Input.is_action_just_pressed("enter") and Global.state.OverworldState == Global.state.OverWorld.MOVING
