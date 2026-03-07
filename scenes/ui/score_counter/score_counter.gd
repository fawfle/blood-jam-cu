extends Label

var last_score: int = 0

var score_to_expand: int = 10

var max_scale: float = 1.2

@onready var expand_timer: Timer = $ExpandTimer

func _process(_delta: float) -> void:
	var score_delta: int = Global.score - last_score
	last_score = Global.score
	if score_delta != 0: print(score_delta)
	
	if score_delta > score_to_expand:
		expand_timer.start()
	
	scale = lerp(Vector2.ONE * max_scale, Vector2.ONE, ease(1 - expand_timer.time_left / expand_timer.wait_time, 5))
	pivot_offset = size / 2
	
	text = str(Global.score)
