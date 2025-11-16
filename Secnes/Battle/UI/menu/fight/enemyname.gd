extends VBoxContainer
@onready var onmain = $"../../.."
@onready var main = $".."
@onready var enemy_container = $"../../../Enemy/EnemyContainer"
@onready var name_labels = [$Label,$Label2,$Label3]

var maxinum = 0
var choice = 0
var can_press = false

func _process(delta: float) -> void:
	if onmain.menu_mode == onmain.menu.act and main.emode == main.state.enemy:
		visible = true
		update_enemy_names()
		heart_position()
		press()
		press_enter()
		exit()
	else:
		visible = false
	
func update_enemy_names():
	for label in name_labels:
		label.text = ""
	
	var enemies = enemy_container.get_children()
	for i in min(enemies.size(), name_labels.size()):
		var enemy = enemies[i]
		var name = ""
		if i == choice:
			name = "  " + enemy.get_display_name()
		elif i != choice:
			name = "* " + enemy.get_display_name()
		name_labels[i].text = name
	maxinum = min(enemies.size(), name_labels.size()) - 1

func add_choice(number: int) -> void:
	choice += number
	var max_idx = min(enemy_container.get_children().size(), name_labels.size()) - 1
	choice = clamp(choice, 0, max(max_idx, 0))

func press():
	if Input.is_action_just_pressed("up"):
		add_choice(-1)
	elif Input.is_action_just_pressed("down"):
		add_choice(1)

func press_enter():
	if Input.is_action_just_pressed("enter"):
		if !can_press:
			can_press = true
			return
		
		if can_press:
			main.choice = choice
			main.emode = main.state.eact

func exit():
	if Input.is_action_just_pressed("shift"):
		can_press = false
		choice = 0
		main.emode = main.state.enemy
		onmain.menu_mode = onmain.menu.none

func heart_position():
	match choice:
		0:
			%Heart.position = Vector2(%Arena.position.x - %Arena.left - 5 + 34, %Arena.position.y - %Arena.up - 5 + 35)
		1:
			%Heart.position = Vector2(%Arena.position.x - %Arena.left - 5 + 34, %Arena.position.y - %Arena.up - 5 + 67)
		2:
			%Heart.position = Vector2(%Arena.position.x - %Arena.left - 5 + 34, %Arena.position.y - %Arena.up - 5 + 134)
