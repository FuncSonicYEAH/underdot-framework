extends Camera2D

var shake_num = 0
var shake_range = 0
var shake_pos = Vector2(0, 0)
var offset_pos = Vector2(0, 0)

func _ready():
	make_current()


func _process(delta):
	shake_num = max(shake_num, 0)
	if shake_num > 0:
		shake_num -= shake_range
		shake_pos.x = randf_range(shake_num, - shake_num)
		shake_pos.y = randf_range(shake_num, - shake_num)
		position.x = offset_pos.x + shake_pos.x
		position.y = offset_pos.y + shake_pos.y
	else:
		shake_pos = Vector2(0, 0)
		position = Vector2(320, 240)


func ShakeScreen(num, range):
	shake_num = num
	shake_range = range
	offset_pos = Vector2(320, 240)

func SetLimit(top = -100000000, bottom = 100000000, left = -100000000, right = 100000000):
	limit_top = top
	limit_bottom = bottom
	limit_left = left
	limit_right = right
