extends RichTextLabel

#========================SIGNALS===============================#
signal tag_opened(name: String, params: Dictionary)
signal tag_closed(name: String)
signal paragraph_finished(paragraph_index: int)
signal typing_start
signal typing_finished
signal typing_end
signal overworld_dialog_face

#========================EXPORT===============================#
@export_group("Typewriter Settings")
@export var default_wait_time: float = 0.04
@export var text_speed_multiplier: float = 60.0

@export_group("Audio Tags")
@export var loud_tag_wait_time: float = 0.6

@export_group("Input Actions")
@export var confirm_action: String = "enter"   # 继续到下一段
@export var skip_action: String = "shift"      # 跳过当前段

#========================CONSTANTS===============================#
const TW_TAG = "[tw]"
const TW_LOUD_TAG = "[tw loud]"
const TW_CLOSE_TAG = "[/tw]"
const CLEAR_TAG = "[clear]"
const PAUSE_TAG = "[pause]"
const END_TAG = "[end]"
const WAIT_TAG_PREFIX = "[wait"
const WAIT_TAG_DEFAULT = "[wait]"
const TW_SKIP_TAG = "[canskip="
const TW_SPEED_PREFIX = "[speed="
const TW_SPEED_CLOSE = "[/speed]"
const FACE_TAG_PREFIX = "[face="
const FACE_TAG_END = "[/face]"
const VOICE_TAG_PREFIX = "[voice="
const VOICE_TAG_END = "[/voice]"
const BATTLE_STATE_TAG_FULL = "[battlestate="
const BATTLE_STATE_TAG_MINI = "[btstate="
const OVERWORLD_STATE_TAG_FULL = "[overworldstate="
const OVERWORLD_STATE_TAG_MINI = "[owstate="

# 特殊标签（不走通用闭合逻辑）
const SPECIAL_OPEN_TAGS = [TW_TAG, TW_LOUD_TAG, CLEAR_TAG, PAUSE_TAG, END_TAG, TW_SKIP_TAG, FACE_TAG_PREFIX, VOICE_TAG_PREFIX, OVERWORLD_STATE_TAG_FULL, OVERWORLD_STATE_TAG_MINI, BATTLE_STATE_TAG_FULL, BATTLE_STATE_TAG_MINI]
const SPECIAL_CLOSE_TAGS = [TW_CLOSE_TAG, TW_SPEED_CLOSE, FACE_TAG_END, VOICE_TAG_END]

#========================VARIABLES===============================#
var _full_text: String = ""
var paragraphs: Array[String] = []
var current_paragraph_index: int = -1

var txt: String = ""
var index: int = 0
var str_length: int = 0
var wait_time: float = 0.0
var accumulate_time: int = 0
var speed_stack: Array[float] = []
var voice: String = "ui"
var face: String = ""

var paused: bool = false
var canskip: bool = true
var skipping: bool = false

var waiting: bool = false
var wait_duration: float = 0.0
var wait_elapsed: float = 0.0

#========================INITIALIZATION===============================#
func _ready() -> void:
	pass

#========================INPUT HANDLING===============================#
func _input(event):
	if event.is_action_pressed(skip_action) and canskip:
		skip_current_paragraph()
	if event.is_action_pressed(confirm_action):
		if paused:
			proceed_to_next_paragraph()

#========================PUBLIC API===============================#
func start_typing(full_text: String) -> void:
	clear()
	emit_signal("typing_start")
	_full_text = full_text
	paragraphs = _split_text_by_pause(_full_text)
	current_paragraph_index = -1
	proceed_to_next_paragraph()  # 开始第一段

func skip_current_paragraph() -> void:
	if current_paragraph_index < 0 or current_paragraph_index >= paragraphs.size():
		return
	if index >= str_length:
		return
	if waiting:
		waiting = false
		wait_elapsed = 0.0
		return
	while index < str_length:
		if txt[index] == "[":
			_handle_tag()
		else:
			append_text(txt.substr(index, 1))
			index += 1
	paused = true

func proceed_to_next_paragraph() -> void:
	if paused == false and current_paragraph_index >= 0:
		return

	current_paragraph_index += 1

	if current_paragraph_index >= paragraphs.size():
		# 全部完成
		paused = false
		emit_signal("typing_finished")
		return

	# 加载新段落
	txt = paragraphs[current_paragraph_index]
	index = 0
	str_length = txt.length()
	speed_stack.clear()
	speed_stack.push_back(default_wait_time * text_speed_multiplier)
	wait_time = speed_stack.back()
	paused = false
	skipping = false

#========================TEXT SPLITTING===============================#
func _split_text_by_pause(text: String) -> Array[String]:
	var parts: Array[String] = []
	var start = 0
	var i = 0
	while i <= text.length():
		if i == text.length():
			parts.append(text.substr(start))
			break
		if text.substr(i, len(PAUSE_TAG)) == PAUSE_TAG:
			parts.append(text.substr(start, i - start))
			i += len(PAUSE_TAG)
			start = i
		else:
			i += 1
	return parts

#========================MAIN PROCESS===============================#
func _physics_process(delta: float) -> void:
	if waiting:
		wait_elapsed += delta
		if wait_elapsed >= wait_duration or skipping:
			waiting = false
			wait_elapsed = 0.0
		return
	if paused:
		return
	accumulate_time += 1
	if accumulate_time >= wait_time:
		accumulate_time = 0
		_process_next()

#========================CORE PROCESSING===============================#
func _process_next() -> void:
	if index >= str_length:
		paused = true
		emit_signal("paragraph_finished", current_paragraph_index)
		return

	if txt[index] == "[":
		_handle_tag()
	elif txt[index] == " " or txt[index] == "\t":
		# 连续输出所有相邻空格，不等待
		var space_count = 0
		var i = index
		while i < str_length and txt[i] == " ":
			space_count += 1
			i += 1
		append_text(" ".repeat(space_count))
		index = i  # 跳过所有空格
	else:
		# 普通字符，正常打字
		append_text(txt.substr(index, 1))
		_voice_play(voice)
		index += 1

#========================TAG HANDLING===============================#
func _handle_tag() -> void:
	# === 1. 优先处理特殊标签 ===
	if _try_match_and_handle(TW_CLOSE_TAG, _handle_tw_close):
		return
	if txt.substr(index, len(TW_SPEED_PREFIX)) == TW_SPEED_PREFIX:
		_handle_tw_speed()
		return
	if _try_match_and_handle(TW_SPEED_CLOSE, _handle_tw_close):
		return
	if _try_match_and_handle(TW_TAG, _handle_tw_normal):
		return
	if _try_match_and_handle(TW_LOUD_TAG, _handle_tw_loud):
		return
	if _try_match_and_handle(CLEAR_TAG, _handle_clear):
		return
	if _try_match_and_handle(END_TAG, _handle_end):
		return
	if _try_match_and_handle(FACE_TAG_END, _handle_face_end):
		return
	if _try_match_and_handle(VOICE_TAG_END, _handle_voice_end):
		return
	if txt.substr(index, len(WAIT_TAG_PREFIX)) == WAIT_TAG_PREFIX:
		_handle_wait()
		return
	if txt.substr(index, len(TW_SKIP_TAG)) == TW_SKIP_TAG:
		_handle_canskip()
		return
	if txt.substr(index, len(FACE_TAG_PREFIX)) == FACE_TAG_PREFIX:
		_handle_face()
		return
	if txt.substr(index, len(VOICE_TAG_PREFIX)) == VOICE_TAG_PREFIX:
		_handle_voice()
		return
	if txt.substr(index, len(OVERWORLD_STATE_TAG_FULL)) == OVERWORLD_STATE_TAG_FULL or txt.substr(index, len(OVERWORLD_STATE_TAG_MINI)) == OVERWORLD_STATE_TAG_MINI:
		_handle_owstate()
		return
	if txt.substr(index, len(BATTLE_STATE_TAG_FULL)) == BATTLE_STATE_TAG_FULL or txt.substr(index, len(BATTLE_STATE_TAG_MINI)) == BATTLE_STATE_TAG_MINI:
		_handle_btstate()
		return
	# 注意：[pause] 不应出现在段内（已被分割），若出现则透传
	_parse_generic_tag()

#========================GENERIC TAG PARSER===============================#
func _parse_generic_tag() -> void:
	var close_bracket = txt.find("]", index)
	if close_bracket == -1:
		append_text(txt.substr(index, 1))
		index += 1
		return
	var full_tag = txt.substr(index, close_bracket - index + 1)
	append_text(full_tag)
	index = close_bracket + 1

#========================SPECIAL TAG HANDLERS===============================#
func _handle_tw_normal() -> void:
	_push_speed(default_wait_time)

func _handle_tw_loud() -> void:
	_push_speed(loud_tag_wait_time)

func _handle_tw_close() -> void:
	_pop_speed()

func _handle_clear() -> void:
	clear()
	
func _handle_end() -> void:
	clear()
	emit_signal("typing_end")
	
func _handle_face_end() -> void:
	face = ""
	
func _handle_voice_end() -> void:
	voice = "ui"

func _handle_canskip() -> void:
	var end = txt.find("]", index)
	if end == -1:
		append_text(txt.substr(index, 1))
		index += 1
		return
	var full = txt.substr(index, end - index + 1)
	var skip_str = full.replace(TW_SKIP_TAG, "").replace("]", "").strip_edges()
	if skip_str == "yes":
		canskip = true
	elif skip_str == "no":
		canskip = false
	index = end + 1 

func _handle_face() -> void:
	var end = txt.find("]", index)
	if end == -1:
		append_text(txt.substr(index, 1))
		index += 1
		return
	var full = txt.substr(index, end - index + 1)
	var face_path = _extract_tag_value(full)
	face = face_path
	index = end + 1 

func _handle_voice() -> void:
	var end = txt.find("]", index)
	if end == -1:
		append_text(txt.substr(index, 1))
		index += 1
		return
	var full = txt.substr(index, end - index + 1)
	var voice_name = _extract_tag_value(full)
	voice = voice_name
	print("Var:"+voice+" Code:"+voice_name)
	index = end + 1 

func _handle_owstate() -> void:
	var end = txt.find("]", index)
	if end == -1:
		append_text(txt.substr(index, 1))
		index += 1
		return
	
	var full = txt.substr(index, end - index + 1)
	var owstate_str = _extract_tag_value(full)
	
	match owstate_str:
		"MOVING":
			Global.state.OverworldState = Global.state.OverWorld.MOVING
		"MENU":
			Global.state.OverworldState = Global.state.OverWorld.MENU
		"DIALOG":
			Global.state.OverworldState = Global.state.OverWorld.DIALOG
		"SAVING":
			Global.state.OverworldState = Global.state.OverWorld.SAVING
	index = end + 1 
	
func _handle_btstate() -> void:
	var end = txt.find("]", index)
	if end == -1:
		append_text(txt.substr(index, 1))
		index += 1
		return
	
	var full = txt.substr(index, end - index + 1)
	var btstate_str = _extract_tag_value(full)
	
	match btstate_str:
		"MENU":
			Global.state.BattleState = Global.state.Battle.MENU
		"ENEMYTRUN":
			Global.state.BattleState = Global.state.Battle.ENEMYTRUN
	index = end + 1 

func _handle_tw_speed() -> void:
	var end = txt.find("]", index)
	if end == -1:
		append_text(txt.substr(index, 1))
		index += 1
		return
	var full = txt.substr(index, end - index + 1)
	var speed_str = full.replace(TW_SPEED_PREFIX, "").replace("]", "").strip_edges()
	var speed = speed_str.to_float()
	if speed <= 0:
		speed = default_wait_time
	_push_speed(speed)
	index = end + 1
	
func _handle_wait() -> void:
	var close_bracket = txt.find("]", index)
	if close_bracket == -1:
		append_text(txt.substr(index, 1))
		index += 1
		return
	var full_tag = txt.substr(index, close_bracket - index + 1)
	index = close_bracket + 1
	var wait_sec = 1.0
	if full_tag != "[wait]":
		var eq = full_tag.find("=")
		if eq != -1:
			var num_str = full_tag.substr(eq + 1, full_tag.length() - eq - 2)
			wait_sec = num_str.to_float()
			if wait_sec <= 0:
				wait_sec = 1.0
	waiting = true
	wait_duration = wait_sec
	wait_elapsed = 0.0

#========================UTILITY===============================#
func _extract_tag_value(tag_str: String) -> String:
	var eq = tag_str.find("=")
	if eq == -1:
		return ""
	return tag_str.substr(eq + 1, tag_str.length() - eq - 2).strip_edges()

func _try_match_and_handle(tag: String, handler: Callable) -> bool:
	if txt.substr(index, len(tag)) == tag:
		handler.call()
		index += len(tag)
		return true
	return false

func _voice_play(sound : String):
	match sound:
		"ui":
			Sounds.ui.play()
		"monster":
			Sounds.monster.play()
		"sans":
			Sounds.sans.play()

func _push_speed(speed: float) -> void:
	speed_stack.push_back(speed * text_speed_multiplier)
	wait_time = speed_stack.back()

func _pop_speed() -> void:
	if speed_stack.size() > 1:
		speed_stack.pop_back()
	wait_time = speed_stack.back()
