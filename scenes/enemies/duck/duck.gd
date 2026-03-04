extends Enemy

@onready var animated_sprite = $AnimatedSprite2D

var run_distance: float = 50

func _on_ready() -> void:
	blood_color = Color(0.78, 0.387, 0.0, 1.0)

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
