extends Enemy

func choose_animation() -> void:
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
	elif velocity.x > 0 && velocity.x > velocity.y:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("run_side")
	elif velocity.x < 0 && velocity.x < velocity.y:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("run_side")
	elif velocity.y < 0 && velocity.y < velocity.x:
		$AnimatedSprite2D.play("run_down")
	elif velocity.y > 0 && velocity.y < velocity.x:
		$AnimatedSprite2D.play("run_up")

func find_direction() -> void:
	var enemy_position: Vector2 = position
	var player_position: Vector2 = player.position
	direction = enemy_position.direction_to(player_position)
	
