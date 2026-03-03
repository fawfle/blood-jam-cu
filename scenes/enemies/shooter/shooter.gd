class_name Shooter extends Enemy

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
	var projectile: Area2D = projectile_scene.instantiate()
	projectile.direction = position.direction_to(player.global_position)
	projectile.global_position = global_position
	projectile.look_at(player.global_position)
	if owner: owner.add_child(projectile)
	else: get_tree().add_child(projectile)
	is_shooting = false

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
	if is_shooting: velocity = Vector2.ZERO

func choose_animation() -> void:
	var orientation = rad_to_deg(velocity.angle())
	var player_direction = position.direction_to(player.global_position)
	if velocity == Vector2.ZERO:
		if player_direction.x > 0:
			animated_sprite.flip_h = true
			animated_sprite.play("shoot")
		else:
			animated_sprite.flip_h = false
			animated_sprite.play("shoot")
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
		animated_sprite.flip_h = false
		animated_sprite.play("run_side")
	elif velocity.x < 0 && velocity.x > velocity.y:
		animated_sprite.flip_h = true
		animated_sprite.play("run_side")
	elif velocity.y > 0 && velocity.y > velocity.x:
		animated_sprite.play("run_down")
	elif velocity.y < 0 && velocity.y > velocity.x:
		animated_sprite.play("run_up")

func _on_timer_timeout() -> void:
	animated_sprite.play("shoot")
	shoot()


func _on_initial_shoot_timer_timeout() -> void:
	animated_sprite.play("shoot")
	shoot()
	shoot_timer.start()
