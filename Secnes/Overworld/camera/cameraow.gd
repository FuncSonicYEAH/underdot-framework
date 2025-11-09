extends Camera2D

var current_tween: Tween

func _ready():
	make_current()

# 移动镜头到目标位置
func move_to(target_position: Vector2, move_duration: float, ease_type: Tween.EaseType = Tween.EASE_IN_OUT, trans_type: Tween.TransitionType = Tween.TRANS_SINE):
	_stop_current_tween()
	current_tween = create_tween()
	current_tween.set_ease(ease_type)
	current_tween.set_trans(trans_type)
	current_tween.tween_property(self, "position", target_position, move_duration)

# 相对移动（偏移）
func move_by(by_offset: Vector2, duration: float, ease_type: Tween.EaseType = Tween.EASE_IN_OUT, trans_type: Tween.TransitionType = Tween.TRANS_SINE):
	move_to(position + by_offset, duration, ease_type, trans_type)

# 缩放（放大/缩小）到目标缩放值
# 注意：zoom 越小画面越大（zoom = Vector2(0.5, 0.5) ⇒ 放大 2 倍）
func zoom_to(target_zoom: Vector2, duration: float, ease_type: Tween.EaseType = Tween.EASE_IN_OUT, trans_type: Tween.TransitionType = Tween.TRANS_SINE):
	_stop_current_tween()
	current_tween = create_tween()
	current_tween.set_ease(ease_type)
	current_tween.set_trans(trans_type)
	current_tween.tween_property(self, "zoom", target_zoom, duration)

# 相对缩放（例如放大 1.2 倍：zoom_by(Vector2(0.833, 0.833))）
# 或更直观地用 scale_factor（>1 放大，<1 缩小）
func zoom_by(scale_factor: float, duration: float, ease_type: Tween.EaseType = Tween.EASE_IN_OUT, trans_type: Tween.TransitionType = Tween.TRANS_SINE):
	if scale_factor <= 0:
		push_error("scale_factor must be > 0")
		return
	var target_zoom = zoom / scale_factor  # 因为 zoom 越小画面越大
	zoom_to(target_zoom, duration, ease_type, trans_type)

# 方便的封装：聚焦到某个节点（中心 + 可选缩放）
func focus_on(target: Node2D, duration: float = 0.5, ease_type: Tween.EaseType = Tween.EASE_IN_OUT, trans_type: Tween.TransitionType = Tween.TRANS_SINE, target_zoom = null):
	if not target:
		push_error("Target node is null")
		return
	if not target.is_inside_tree():
		push_error("Target node is not in the scene tree")
		return

	_stop_current_tween()
	current_tween = create_tween()
	current_tween.set_ease(ease_type)
	current_tween.set_trans(trans_type)

	# 移动到目标中心
	current_tween.tween_property(self, "position", target.global_position, duration)

	# 可选：同时缩放
	if target_zoom:
		current_tween.tween_property(self, "zoom", target_zoom, duration)

# 内部工具：安全停止当前 tween
func _stop_current_tween():
	if current_tween and current_tween.is_valid():
		current_tween.kill()
	current_tween = null
