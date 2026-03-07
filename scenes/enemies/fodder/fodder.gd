extends Enemy

@onready var animated_sprite = $AnimatedSprite2D

@onready var max_escape_distance: float = 100.0


func _on_ready() -> void:
	elite_speed = 100

# func bouncing: bool = false

func choose_animation() -> void:
	if velocity == Vector2.ZERO:
		animated_sprite.play("idle")
	elif abs(velocity.x) > abs(velocity.y):
		animated_sprite.flip_h = velocity.x > 0
		animated_sprite.play("run_side")
	elif velocity.y > 0 and abs(velocity.y) > abs(velocity.x):
		animated_sprite.play("run_down")
	elif velocity.y < 0 and abs(velocity.y) > abs(velocity.x):
		animated_sprite.play("run_up")

func find_direction() -> void:
	if global_position.distance_to(player.position) > max_escape_distance:
		move_in_direction_until(0.4)
		return

	var enemy_position: Vector2 = position
	var player_position: Vector2 = player.position
	direction = -enemy_position.direction_to(player_position)
