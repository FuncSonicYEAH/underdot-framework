extends Control
@onready var onmain = $"../../.."
@onready var main = $".."
@onready var enemy_container = $"../../../Enemy/EnemyContainer"
@onready var name_labels = [$act1,$act2,$act3,$act4,$act5,$act6]

func _process(delta: float) -> void:
	if onmain.menu_mode == onmain.menu.act and main.emode == main.state.eact:
		visible = true
		update_enemy_acts()
		exit()
	else:
		visible = false
	
func update_enemy_acts():
	for label in name_labels:
		label.text = ""
	
	var enemies = enemy_container.get_children()
	for i in min(enemies.size(), name_labels.size()):
		var enemy = enemies[main.choice]
		if enemy.has_method("get_display_acts"):
			name_labels[i].text = enemy.get_display_acts(i)
		elif enemy.has_signal("ready"):
			name_labels[i].text = "* " + enemy.acts

func exit():
	if Input.is_action_just_pressed("shift"):
		main.emode = main.state.enemy
		main.choice = 0
