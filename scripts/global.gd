extends Node

var blood: float = 100

var room_size: Vector2i = Vector2i(288, 162)

var player: Player
var ground: Ground
var main: Main

## signal enemy sends when getting eaten
@warning_ignore("unused_signal")
signal enemy_eaten(enemy: Enemy)


## when room gets resized
@warning_ignore("unused_signal")
signal room_resized(size: Vector2i)
