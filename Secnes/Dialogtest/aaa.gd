extends Node2D

var example_text = "[canskip=yes]* There's that prophecy again.\n  The one with... us.\n  The one with... you.[pause][end]"

func _ready() -> void:
	$Dialog._new(example_text)
