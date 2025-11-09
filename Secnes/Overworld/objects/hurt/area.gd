extends Area2D

@onready var player = $"../../CharacterBody2D"
@onready var camera = $"../../CharacterBody2D/Camera"

func _process(delta: float) -> void:
	if has_overlapping_areas():
		if player.InputConfirm():
			camera.zoom_by(0.8,0.5)
