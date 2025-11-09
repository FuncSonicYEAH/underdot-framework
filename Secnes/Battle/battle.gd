extends Node2D

func _ready() -> void:
	Global.state.BattleState = Global.state.Battle.ENEMYTRUN
	%Heart.HeartMode = %Heart.mode.blue
	%Heart.position = Vector2(320,320)
	$Control/Typer.start_typing("[font=res://Fonts/DTM-Spacing/DTM-Battle.tres]* You feel you will have a\n[color=#ff0000][shake rate=20 level=20]  bad time[/shake][/color]")

func _process(delta: float) -> void:
	print(str(Global.state.BattleState))
	
	if Input.is_action_just_pressed("shift"):
		$Control/Typer.start_typing("* Fuck you")
		%Arena.resize(70,70,70,70,Tween.TRANS_CUBIC,Tween.EaseType.EASE_OUT)
