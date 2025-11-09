extends Control

# —— 配置参数（可暴露到 Inspector）
@export var heart_positions: Array[Vector2] = [Vector2(160, 292), Vector2(336, 292)]
@export var exit_delay_seconds: float = 2.0  # 120帧 @60FPS = 2秒

# —— 内部状态
enum Mode { NO_SAVE, SAVING }
var mode: Mode = Mode.NO_SAVE
var choose: int = 0
var exit: bool = false
var _exit_elapsed: float = 0.0

# —— 缓存节点（避免每帧查树）
@onready var heart_node: Node2D = $HeartOw
@onready var player_node: Node2D = $"../../CharacterBody2D"


func _process(delta: float) -> void:
	if Global.state.OverworldState == Global.state.OverWorld.SAVING:
		Global.player.data1.is_save_load()
		Global.player.data1.load_gamedata()
		visible = true

		# 仅当需要时更新 UI & 选择
		if mode == Mode.NO_SAVE:
			_handle_input()
			_update_heart_position()

		# 自动退出逻辑
		if exit:
			_exit_elapsed += delta
			if _exit_elapsed >= exit_delay_seconds:
				_finish_exit()

	else:
		visible = false
		# 可选：重置状态以防异常中断
		if exit:
			reset()


func _handle_input() -> void:
	if Input.is_action_just_pressed("left"):
		Sounds.choose.play()
		choose = clamp(choose - 1, 0, 1)
	elif Input.is_action_just_pressed("right"):
		Sounds.choose.play()
		choose = clamp(choose + 1, 0, 1)
	elif Input.is_action_just_pressed("enter") and not exit:
		match choose:
			0: _do_save()
			1: _do_cancel()


func _update_heart_position() -> void:
	if heart_node:
		heart_node.position = heart_positions[choose] if choose < heart_positions.size() else Vector2.ZERO


func _do_save() -> void:
	Sounds.save.play()
	Global.player.data1.is_save = true
	Global.player.data1.room_save_name = Global.player.room_name
	Global.player.data1.save_room = get_tree().current_scene.scene_file_path
	print(Global.player.data1.room_save_name)

	if player_node:
		Global.player.data1.save_position = player_node.global_position
	else:
		push_warning("SaveMenu: Player node not found for saving position!")

	mode = Mode.SAVING
	Global.player.data1.save_gamedata()
	exit = true
	_exit_elapsed = 0.0


func _do_cancel() -> void:
	Global.state.OverworldState = Global.state.OverWorld.MOVING
	reset()


func _finish_exit() -> void:
	Global.state.OverworldState = Global.state.OverWorld.MOVING
	reset()


func reset() -> void:
	mode = Mode.NO_SAVE
	choose = 0
	exit = false
	_exit_elapsed = 0.0
