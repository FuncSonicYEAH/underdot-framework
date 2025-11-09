extends Area2D

@onready var player = $"../CharacterBody2D"

func _physics_process(delta: float) -> void:
	if has_overlapping_areas():
		if player.InputConfirm():
			$"../GUI/Dialog"._new("[color=#ff0000]"+tr("saving_dtm")+"[/color][pause][end][overworldstate=SAVING]")
