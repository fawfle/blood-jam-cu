extends Enemy

@onready var animated_sprite = $AnimatedSprite2D
@export var shot_distance: int
var flame_scene: PackedScene = preload("res://scenes/enemies/flame/Flame.tscn")
var is_flaming = false
var cur_flame

func flame() -> void:
	if is_flaming: return
	is_flaming = true
	cur_flame = flame_scene.instantiate()
	cur_flame.flamer = self
	if owner: owner.add_child(cur_flame)
	else: get_tree().add_child(cur_flame)

func choose_animation() -> void:
	if is_flaming && velocity.x > 0:
		animated_sprite.flip_h = true
		animated_sprite.play("run_side")
	elif is_flaming && velocity.x < 0:
		animated_sprite.flip_h = false
		animated_sprite.play("run_side")
	elif velocity == Vector2.ZERO:
		animated_sprite.play("idle")
	elif velocity.x > 0 && velocity.x > velocity.y:
		animated_sprite.flip_h = true
		animated_sprite.play("run_side")
	elif velocity.x < 0 && velocity.x > velocity.y:
		animated_sprite.flip_h = false
		animated_sprite.play("run_side")
	elif velocity.y > 0 && velocity.y > velocity.x:
		animated_sprite.play("run_down")
	elif velocity.y < 0 && velocity.y > velocity.x:
		animated_sprite.play("run_up")

func find_direction() -> void:
	if position.distance_to(player.position) > shot_distance:
		direction = position.direction_to(player.position)
	else:
		flame()
		
func die():
	dying = true
	set_shields(false)
	await move_towards_player()
	if not dying:
		set_shields(true)
		return
	Global.blood += blood
	Global.enemy_eaten.emit(self)
	#set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	if Global.ground: Global.ground.paint_circle_color(global_position, randi_range(6,6), BLOOD_COLOR, true)
	#set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	if cur_flame: cur_flame.queue_free()
	queue_free()
