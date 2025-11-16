extends Node2D
enum menu {none,fight,act,item,mercy}
var menu_mode = menu.none

@onready var enemy_container = $Enemy/EnemyContainer

func _ready():
	$Control/Typer.start_typing("* aaaaaaaaaaaaaaaaa")
	spawn_enemy("res://Secnes/Battle/enemy/test/enemy.tscn")
	spawn_enemy("res://Secnes/Battle/enemy/test2/enemy.tscn")

func spawn_enemy(scene_path: String):
	var scene = load(scene_path)
	if not scene:
		push_error("Failed to load enemy: ", scene_path)
		return
	var enemy = scene.instantiate()
	enemy_container.add_child(enemy)
