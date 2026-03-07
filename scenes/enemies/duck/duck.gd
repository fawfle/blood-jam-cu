extends Enemy

@onready var animated_sprite = $AnimatedSprite2D
@onready var area_collision_shape = $Area2D/CollisionShape2D
@onready var body_collision_shape = $CollisionShape2D

var run_distance: float = 50

var elite_scale: float = 2

func _on_ready() -> void:
	blood_color = Color(0.78, 0.387, 0.0, 1.0)
	
	elite = true

func choose_animation() -> void:
	if velocity == Vector2.ZERO:
		animated_sprite.play("idle")
	elif velocity.x > 0:
		animated_sprite.flip_h = true
		animated_sprite.play("run_side")
	elif velocity.x < 0:
		animated_sprite.flip_h = false
		animated_sprite.play("run_side")
		
func find_direction() -> void:
	if position.distance_to(player.position) < run_distance:
		move_in_direction = false
		direction = -position.direction_to(player.position)
	else:
		if not move_in_direction:
			direction = Vector2.from_angle(randf() * PI * 2)
			move_in_direction_until(0.5)

func on_elite_changed():
	animated_sprite.scale = Vector2.ONE * elite_scale
	## i love magic numbers. Just the scale in inspector hardcoded
	area_collision_shape.shape.radius = 5 * elite_scale
	body_collision_shape.shape.radius = 6 * elite_scale
