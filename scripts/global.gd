extends Node

var blood: float = 100

var room_size: Vector2i = Vector2i(288 - 10, 162 - 10)
var start_room_size: Vector2i = room_size

var player: Player
var ground: Ground
var main: Main

## signal enemy sends when getting eaten
@warning_ignore("unused_signal")
signal enemy_eaten(enemy: Enemy)


## when room gets resized
@warning_ignore("unused_signal")
signal room_resized(size: Vector2i)

const spawn_padding: float = 5

var room_size_ratio: float:
	get: return room_size.length() / start_room_size.length()

func random_position_in_room() -> Vector2:
	return Vector2(randf_range(-room_size.x / 2.0 + spawn_padding, room_size.x / 2.0 - spawn_padding), randf_range(-room_size.y/2.0 + spawn_padding, room_size.y/2.0 - spawn_padding))

func get_min_spawn_distance() -> float:
	var min_spawn_distance: float = max(30.0, room_size.length() / 3)
	return min_spawn_distance

func get_max_spawn_distance() -> float:
	return room_size.length() / 2.0

const MAX_ITERATIONS = 20

func random_position_in_room_away_from_player() -> Vector2:
	var random_pos = Global.random_position_in_room()
	var iterations: int = 0
	while random_pos.distance_to(Global.player.global_position) < get_min_spawn_distance() or random_pos.distance_to(Global.player.global_position) > get_max_spawn_distance():
		iterations += 1
		random_pos = Global.random_position_in_room()
		
		if iterations >= MAX_ITERATIONS:
			push_error("random_position_in_room_away_from_player exceeded MAXIMUM_ITERATIONS")
			break
	
	return random_pos
