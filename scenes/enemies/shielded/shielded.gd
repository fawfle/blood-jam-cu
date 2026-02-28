extends Enemy

# shield guy works similarly to shooter, but min distance will change
@export var distance_min: int
var distances = [100,200,300]
var distIndex = 0;

func change_distance() -> void:
	distIndex = (distIndex + 1) % len(distances)

func find_direction() -> void:
	var enemy_position: Vector2 = position
	var player_position: Vector2 = player.position
	var distance: float = enemy_position.distance_to(player_position)
	# if player too close, go away from player otherwise go towards 
	if distance < distances[distIndex]:
		direction = -enemy_position.direction_to(player_position)
	else:
		direction = enemy_position.direction_to(player_position)

func _on_timer_timeout() -> void:
	change_distance()
