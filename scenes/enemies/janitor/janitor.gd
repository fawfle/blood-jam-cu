extends Enemy

func choose_animation() -> void:
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
	elif velocity.x > 0 && velocity.x > velocity.y:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("movement")
	elif velocity.x < 0 && velocity.x > velocity.y:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("movement")

func find_direction() -> void:
	var enemy_position: Vector2 = position
	var player_position: Vector2 = player.position
	direction = enemy_position.direction_to(player_position)

func clean_blood() -> void:
	pass
