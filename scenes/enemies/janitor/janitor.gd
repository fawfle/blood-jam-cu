extends Enemy

@export var clean_radius := 20

func _process(_delta: float) -> void:
	clean_blood()
	find_direction()

func choose_animation() -> void:
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
	elif velocity.x > 0 && velocity.x > velocity.y:
		$AnimatedSprite2D.flip_h = true
		if $AnimatedSprite2D.animation != "movement":
			$AnimatedSprite2D.play("movement")
	elif velocity.x < 0 && velocity.x > velocity.y:
		$AnimatedSprite2D.flip_h = false
		if $AnimatedSprite2D.animation != "movement":
			$AnimatedSprite2D.play("movement")

func find_direction() -> void:
	var enemy_position: Vector2 = position
	var player_position: Vector2 = player.position
	direction = enemy_position.direction_to(player_position)

func clean_blood() -> void:
	if Global.ground == null: return
	var painted: int = Global.ground.clear_circle(position, clean_radius)
	velocity = velocity.move_toward(Vector2.ZERO, painted)
