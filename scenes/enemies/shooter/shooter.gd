class_name Shooter extends Enemy

# time to wait before shooting
@export var shoot_time: float = 0.25
# minimum distance away from player shooter enemy needs to be
@export var distance_target: int = 120
var projectile_scene: PackedScene = preload("res://scenes/enemies/projectile/projectile.tscn")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var initial_shoot_timer: Timer = $InitialShootTimer

const DISTANCE_TOLERANCE: float = 2.0
var is_shooting = false

func shoot() -> void:
	is_shooting = true
	move_in_direction = false
	panicking = false
	await get_tree().create_timer(shoot_time).timeout
	#var projectile: Area2D = projectile_scene.instantiate()
	#projectile.direction = position.direction_to(player.global_position)
	#projectile.global_position = global_position
	#projectile.look_at(player.global_position)
	#if owner: owner.add_child(projectile)
	#else: get_tree().add_child(projectile)
	create_projectile_in_direction(position.direction_to(player.global_position))
	if elite:
		create_projectile_in_direction(position.direction_to(player.global_position).rotated(PI / 6))
		create_projectile_in_direction(position.direction_to(player.global_position).rotated(-PI / 6))
	is_shooting = false

func create_projectile_in_direction(dir: Vector2):
	var projectile: Area2D = projectile_scene.instantiate()
	projectile.direction = dir
	projectile.global_position = global_position
	projectile.rotation = dir.angle()
	if owner: owner.add_child(projectile)
	else: get_tree().add_child(projectile)

func find_direction() -> void:
	var player_position: Vector2 = player.global_position
	var distance: float = global_position.distance_to(player_position)
	# if player too close, go away from player otherwise go towards 
	if abs(distance - distance_target) < DISTANCE_TOLERANCE:
		direction = Vector2.ZERO
	elif distance < distance_target:
		direction = -global_position.direction_to(player_position)
	elif distance > distance_target:
		direction = global_position.direction_to(player_position)
	else:
		direction = Vector2.ZERO
	
	if is_shooting: direction = Vector2.ZERO

func choose_animation() -> void:
	
	var player_direction = position.direction_to(player.global_position)
	
	var look_direction: Vector2 = velocity
	if is_shooting:
		look_direction = player_direction
	var orientation = rad_to_deg(look_direction.angle())
	
	animated_sprite.speed_scale = 1 if not is_shooting else 0
	
	if orientation < -15 && orientation > -60:
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
	elif abs(look_direction.x) > abs(look_direction.y):
		animated_sprite.flip_h = look_direction.x > 0
		if is_shooting:
			animated_sprite.play("shoot")
		else:
			animated_sprite.play("run_side")
	elif look_direction.y > 0 && abs(look_direction.y) > abs(look_direction.x):
		animated_sprite.play("run_down")
	elif look_direction.y < 0 && abs(look_direction.y) > abs(look_direction.x):
		animated_sprite.play("run_up")

func _on_timer_timeout() -> void:
	if Global.player.dead: return
	shoot()


func _on_initial_shoot_timer_timeout() -> void:
	shoot()
	shoot_timer.start()
