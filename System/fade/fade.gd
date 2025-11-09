extends CanvasLayer
@onready var anim = $Anim

func fade_config(mode = "fade_in", goto_room = ""):
	visible = true
	anim.play(mode)
	if mode == "fade_out" and goto_room != "":
		await anim.animation_finished
		get_tree().change_scene_to_file(goto_room)
		visible = false
