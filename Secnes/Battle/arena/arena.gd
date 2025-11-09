extends Node2D
@onready var outer = $Outer
@onready var inner = $Inner
@onready var mask = $mask
@onready var static_body = $StaticBody
@onready var player: CharacterBody2D = %Heart
@onready var area: Area2D = $ArenaArea
@onready var shape: CollisionShape2D = $ArenaArea/Shape
@onready var static_body_2: Area2D = $StaticBody2







const Thickness = 5.0


@export var up = 65
@export var down = 65
@export var left = 283
@export var right = 283

var moving = false
var stretching = false
var pos = Vector2(0, 0)
func _ready():
	z_index = Global.index.arena


func _process(delta):
	init_shape()
	outer.polygon[0] = Vector2(-left - 5, -up - 5)
	inner.polygon[0] = Vector2(-left, -up)
	outer.polygon[1] = Vector2(right + 5, -up - 5)
	inner.polygon[1] = Vector2(right, -up)
	outer.polygon[2] = Vector2(right + 5, down + 5)
	inner.polygon[2] = Vector2(right, down)
	outer.polygon[3] = Vector2(-left - 5, down + 5)
	inner.polygon[3] = Vector2(-left, down)
	
	
	mask.scale = Vector2((left + right) / 1000.0, (up + down) / 1000.0)
	mask.position.x = (-left + right) / 2.0
	mask.position.y = (-up + down) / 2.0
	
	
	shape.scale = Vector2(max(left + right, 0), max(up + down, 0))
	area.position.x = (-left + right) / 2.0
	area.position.y = (-up + down) / 2.0
	
	
	var check = false
	area.soul_check = 0
	for i in area.get_overlapping_areas().size() :
		if str(area.get_overlapping_areas()[i]).find("ArenaArea") != -1 :
			for k in area.get_overlapping_areas().size() :
				if str(area.get_overlapping_areas()[k]).find("box") != -1 :
					area.soul_check += 1
			area.arena_max = 0
			for c in static_body_2.get_overlapping_areas().size() :
				if str(static_body_2.get_overlapping_areas()[c]).find("box") != -1 :
					area.arena_max += 1
			if area.arena_max >= 1 and area.get_overlapping_areas()[i].arena_max >= 1 :
				check = true
				break
			if area.soul_check >= 1 and area.get_overlapping_areas()[i].soul_check >= 1 :
				check = false
				break
		else:
			for j in area.get_overlapping_areas().size() :
				if str(area.get_overlapping_areas()[j]).find("ArenaArea") != -1 :
					if not area.get_overlapping_areas()[j].check :
						check = true
				else:
					check = true
	
	for i in area.get_overlapping_areas().size() :
		if check :
			if str(area.get_overlapping_areas()[i]).find("box") != -1 :
				for j in static_body.get_child_count() :
					static_body.get_child(j).disabled = false
		else:
			for j in static_body.get_child_count() :
				static_body.get_child(j).disabled = true
	area.check = check
	

func _physics_process(delta: float) -> void:
	if player and player.is_inside_tree() and Global.state.BattleState == Global.state.Battle.ENEMYTRUN:
		var arena_center = Vector2(position.x + (-left + right) / 2.0,position.y + (-up + down) / 2.0)
		var bound_left = arena_center.x - left
		var bound_right = arena_center.x + right
		var bound_top = arena_center.y - up
		var bound_bottom = arena_center.y + down

		player.position.x = clamp(player.position.x, bound_left, bound_right)
		player.position.y = clamp(player.position.y, bound_top, bound_bottom)

func move_to(x = null, y = null, speed = 0.5, trans : Tween.TransitionType = Tween.TRANS_LINEAR, ease : Tween.EaseType = Tween.EASE_IN, with_heart : bool = true):
	if not moving:
		moving = true

		var target_pos = Vector2(x if x != null else position.x,y if y != null else position.y)

		var heart_local_offset = Vector2.ZERO
		if with_heart and player:
			heart_local_offset = player.position - position
		
		var new_speed = speed == null
		var duration = speed if not new_speed else (target_pos - position).length() * 0.008

		var tween = create_tween()
		tween.tween_property(self, "position", target_pos, duration).set_trans(trans).set_ease(ease)

		if with_heart and player:
			var tween_heart = create_tween()
			tween_heart.tween_method(func(current_t):player.position = self.position + heart_local_offset,0.0,1.0,duration).set_trans(trans).set_ease(ease)

		await tween.finished
		moving = false

func resize(_up, _down, _left, _right, trans : Tween.TransitionType = Tween.TRANS_LINEAR, ease : Tween.EaseType = Tween.EASE_IN, speed = null):
	if not stretching:
		stretching = true
		var new_speed = false
		if not speed :
			new_speed = true
		var tween_up = create_tween()
		var tween_down = create_tween()
		var tween_left = create_tween()
		var tween_right = create_tween()
		var min_w = min(_left - left, _right - right)
		var min_h = min(_up - up, _down - down)
		if new_speed :
			tween_up.tween_property(self, "up", _up, abs(min_h)*0.002).set_trans(trans).set_ease(ease)
			tween_down.tween_property(self, "down", _down, abs(min_h)*0.002).set_trans(trans).set_ease(ease)
			tween_left.tween_property(self, "left", _left, abs(min_w)*0.002).set_trans(trans).set_ease(ease)
			tween_right.tween_property(self, "right", _right, abs(min_w)*0.002).set_trans(trans).set_ease(ease)
		else:
			tween_up.tween_property(self, "up", _up, speed).set_trans(trans).set_ease(ease)
			tween_down.tween_property(self, "down", _down, speed).set_trans(trans).set_ease(ease)
			tween_left.tween_property(self, "left", _left, speed).set_trans(trans).set_ease(ease)
			tween_right.tween_property(self, "right", _right, speed).set_trans(trans).set_ease(ease)
		await tween_up.finished
		await tween_right.finished
		stretching = false
		


func init_shape():
	var xscale = left + right
	var yscale = up + down
	var posx = -left + right
	var posy = -up + down
	static_body.get_child(0).position = Vector2(posx/2, -(up + Thickness * 0.5))
	static_body.get_child(1).position = Vector2(posx/2, (down + Thickness * 0.5))
	static_body.get_child(2).position = Vector2(-(left + Thickness * 0.5), posy/2)
	static_body.get_child(3).position = Vector2((right + Thickness * 0.5), posy/2)
	
	static_body.get_child(0).scale = Vector2(xscale + Thickness * 2.0, Thickness)
	static_body.get_child(1).scale = Vector2(xscale + Thickness * 2.0, Thickness)
	static_body.get_child(2).scale = Vector2(Thickness, yscale + Thickness * 2.0)
	static_body.get_child(3).scale = Vector2(Thickness, yscale + Thickness * 2.0)
	
	static_body_2.get_child(0).position = Vector2(posx/2, -(up + 1))
	static_body_2.get_child(1).position = Vector2(posx/2, (down + 1))
	static_body_2.get_child(2).position = Vector2(-(left + 1), posy/2)
	static_body_2.get_child(3).position = Vector2((right + 1), posy/2)
	
	static_body_2.get_child(0).scale = Vector2(xscale, 0.5)
	static_body_2.get_child(1).scale = Vector2(xscale, 0.5)
	static_body_2.get_child(2).scale = Vector2(0.5, yscale)
	static_body_2.get_child(3).scale = Vector2(0.5, yscale)
