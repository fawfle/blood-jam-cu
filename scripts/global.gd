extends Node

var blood: float = 100

var player: Player
var ground: Ground

## signal enemy sends when getting eaten
@warning_ignore("unused_signal")
signal enemy_eaten(enemy: Enemy)
