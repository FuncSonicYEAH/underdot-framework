extends Node2D
var dir = "up"
enum Mode{none,item,stat,call}
var menumode = Mode.none

func _process(delta: float) -> void:
	if menumode != Mode.none:
		return
	
	if Global.state.OverworldState == Global.state.OverWorld.MENU:
		visible = true
		if Input.is_action_just_pressed("shift"):
			Global.state.OverworldState = Global.state.OverWorld.MOVING
	else:
		visible = false
	
	if dir == "up": 
		$up.visible = true
		$down.visible = false
	elif dir == "down": 
		$down.visible = true
		$up.visible = false
	
	if Input.is_action_just_pressed("ctrl") and Global.state.OverworldState not in [Global.state.OverWorld.DIALOG, Global.state.OverWorld.SAVING]:
		Global.state.OverworldState = Global.state.OverWorld.MENU
