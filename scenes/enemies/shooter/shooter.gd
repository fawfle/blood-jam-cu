extends Enemy

# minimum distance away from player shooter enemy needs to be
@export var distance_target: int = 120
var projectile_scene: PackedScene = preload("res://scenes/enemies/projectile/projectile.tscn")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const DISTANCE_TOLERANCE: float = 2.0

func shoot() -> void:
	var projectile: Area2D = projectile_scene.instantiate()
	projectile.direction = position.direction_to(player.global_position)
	projectile.global_position = global_position
	projectile.look_at(player.global_position)
	
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

func choose_animation() -> void:
	if velocity == Vector2.ZERO:
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

func _on_timer_timeout() -> void:
	shoot()
