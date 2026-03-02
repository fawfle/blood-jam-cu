extends Node

var enemies_killed: int = 0
var expansion_num: int = 0

func _process(_delta: float) -> void:
	@warning_ignore("integer_division")
	Global.score = enemies_killed * 20 + expansion_num * 100 + int(Global.game_time / 1000) * 2 + Global.ground.filled_pixels/1000
	
func _on_timer_timeout() -> void:
	Global.game_time += 1000
