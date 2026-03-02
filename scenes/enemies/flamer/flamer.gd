extends Enemy

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var shot_distance: int = 80

@export var rotation_speed: float = 0.5

var flame_scene: PackedScene = preload("res://scenes/enemies/flame/Flame.tscn")
var is_flaming = false
var flame: Flame

@onready var flame_pivot: Node2D = $FlamePivot

func start_flaming() -> void:
	if is_flaming: return
	is_flaming = true
	flame = flame_scene.instantiate()
	
	flame_pivot.add_child(flame)
	flame.owner = flame_pivot
	
	flame.position = Vector2(24, 0)
	flame_pivot.look_at(Global.player.global_position)

func stop_flaming() -> void:
	if not is_flaming: return
	is_flaming = false
	flame.queue_free()
	flame = null

func _on_physics_process(delta: float):
	if flame == null: return
	
	var angle_to_player: float = flame_pivot.get_angle_to(Global.player.global_position)
	var rotate_angle: float = max(abs(angle_to_player), rotation_speed) * sign(angle_to_player)
	
	flame_pivot.rotate(rotate_angle * delta)
	flame.animated_sprite.flip_h = abs(flame_pivot.rotation_degrees) > PI / 2

func choose_animation() -> void:
	#if is_flaming && velocity.x > 0:
	#	animated_sprite.flip_h = true
	#	animated_sprite.play("run_side")
	#elif is_flaming && velocity.x < 0:
	#	animated_sprite.flip_h = false
	#	animated_sprite.play("run_side")
	var orientation = rad_to_deg(velocity.angle())
	print(orientation)
	if velocity == Vector2.ZERO:
		animated_sprite.play("idle")
	elif orientation < -15 && orientation > -60:
		animated_sprite.flip_h = true
		animated_sprite.play("run_45_up")
	elif orientation < -105 && orientation > -150:
		animated_sprite.flip_h = false
		animated_sprite.play("run_45_up")
	elif orientation > 105 && orientation < 150:
		animated_sprite.flip_h = false
		animated_sprite.play("run_45_down")
	elif orientation > 15 && orientation < 60:
		animated_sprite.flip_h = true
		animated_sprite.play("run_45_down")
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
		stop_flaming()
	else:
		start_flaming()
		direction = Vector2.from_angle(get_angle_to((flame.global_position)))
		
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
	if Global.ground: Global.ground.paint_circle_color(global_position, randi_range(6,6), blood_color, true)
	#set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	if flame: flame.queue_free()
	queue_free()
