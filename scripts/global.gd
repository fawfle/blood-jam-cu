extends Node

var blood: float = 100

var room_size: Vector2i = Vector2i(288 - 10, 162 - 10)

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

func random_position_in_room() -> Vector2:
	return Vector2(randf_range(-room_size.x / 2.0 + spawn_padding, room_size.x / 2.0 - spawn_padding), randf_range(-room_size.y/2.0 + spawn_padding, room_size.y/2.0 - spawn_padding))
