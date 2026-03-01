extends Enemy

@onready var animated_sprite = $AnimatedSprite2D

@onready var max_escape_distance: float = 240.0

# func bouncing: bool = false

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

func find_direction() -> void:
	if global_position.distance_to(player.position) > max_escape_distance:
		move_in_direction_until(0.4)
		return
	
	var enemy_position: Vector2 = position
	var player_position: Vector2 = player.position
	direction = -enemy_position.direction_to(player_position)
