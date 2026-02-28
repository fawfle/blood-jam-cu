extends Enemy

# minimum distance away from player shooter enemy needs to be
@export var distance_min: int 
@export var Projectile: PackedScene

func shoot() -> void:
	var shot_projectile = Projectile.instantiate()
	shot_projectile.direction = position.direction_to(player.position)
	shot_projectile.position = position
	owner.add_child(shot_projectile)

func find_direction() -> void:
	var enemy_position: Vector2 = position
	var player_position: Vector2 = player.position
	var distance: float = enemy_position.distance_to(player_position)
	# if player too close, go away from player otherwise go towards 
	if distance < distance_min:
		direction = -enemy_position.direction_to(player_position)
	else:
		direction = enemy_position.direction_to(player_position)

func _on_timer_timeout() -> void:
	shoot()
