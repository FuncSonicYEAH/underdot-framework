extends Node

# —— 节点引用 ——————————————————————————————————————————————
@onready var typer: = $Typer # 建议指定具体类型（假设 Typer 是自定义节点）
@onready var broad: = $Caja
@onready var face: = $Face

# —— 硬编码常量提取 ——————————————————————————————————————————
const DIALOG_HEIGHT_THRESHOLD := 240
const TOP_POSITION := Vector2(320, 90)
const BOTTOM_POSITION := Vector2(320, 396)

const FACE_DEFAULT_X := -263
const FACE_WITH_FACE_X := -143
const TYPING_Y_OFFSET := -58

# —— 缓存面部纹理的字典，避免重复 load() ————————————————
var _face_cache := {}

# —— 状态 ————————————————————————————————————————————————————
var direction := "up"


func _ready() -> void:
	_set_visibility(false)


func _new(text: String) -> void:
	if text.is_empty():
		push_warning("Dialog text is empty!")
		return

	# 更新全局状态（防御性检查）
	if Global.state.OverworldState != Global.state.OverWorld.DIALOG and Global.state.OverworldState != Global.state.OverWorld.SAVING:
		Global.state.OverworldState = Global.state.OverWorld.DIALOG

	typer.start_typing(text)


func _process(delta: float) -> void:
	_update_face_position()
	_update_dialog_position()


# —— 私有方法 ————————————————————————————————————————————————

func _update_face_position() -> void:
	var face_name = typer.face
	
	if face_name.is_empty():
		face.texture = null
		typer.position = Vector2(FACE_DEFAULT_X, TYPING_Y_OFFSET)
	else:
		if not _face_cache.has(face_name):
			var path = "res://Sprites/typer/face/" + face_name
			var texture := load(path) as Texture2D
			if texture:
				_face_cache[face_name] = texture
			else:
				push_error("Failed to load face texture: %s" % path)
				face.texture = null
				typer.position = Vector2(FACE_DEFAULT_X, TYPING_Y_OFFSET)
				return
		
		face.texture = _face_cache[face_name]
		typer.position = Vector2(FACE_WITH_FACE_X, TYPING_Y_OFFSET)


func _update_dialog_position() -> void:
	var player_y = Global.player.player_pos_screen.y
	if player_y > DIALOG_HEIGHT_THRESHOLD:
		$".".position = TOP_POSITION
	else:
		$".".position = BOTTOM_POSITION


func _set_visibility(visible: bool) -> void:
	$".".visible = visible
	typer.visible = visible
	broad.visible = visible
	face.visible = visible


# —— 信号回调 ——————————————————————————————————————————————

func _on_typer_typing_start() -> void:
	_set_visibility(true)


func _on_typer_typing_end() -> void:
	_set_visibility(false)
	typer.face = ""
