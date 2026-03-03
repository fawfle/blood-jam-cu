extends Node

var enemies_killed: int = 0
var expansion_num: int = 0

func _ready() -> void:
	Global.enemy_eaten.connect(_on_enemy_death)
	Global.room_resized.connect(_on_room_resized)

func _process(_delta: float) -> void:
	@warning_ignore("integer_division")
	Global.score = enemies_killed * 10 + int(pow(10 * expansion_num, 2)) + int(Global.game_time / 1000) * 2 + Global.ground.filled_pixels/1000

func _on_enemy_death(_enemy: Enemy):
	enemies_killed += 1

func _on_room_resized(_size: Vector2i):
	expansion_num += 1
