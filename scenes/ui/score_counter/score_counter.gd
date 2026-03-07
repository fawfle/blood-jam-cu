extends Label

var last_score_deltas: Array[int] = []
var last_score: int = 0

var score_to_expand: int = 15

var max_scale: float = 1.2

const CHECK_FRAMES: int = 10

@onready var expand_timer: Timer = $ExpandTimer

func _physics_process(_delta: float) -> void:
	if Global.game_over: return
	
	var score_delta: int = Global.score - last_score
	last_score = Global.score
	
	last_score_deltas.append(score_delta)
	if last_score_deltas.size() > CHECK_FRAMES: last_score_deltas.pop_front()
	
	var last_score_deltas_sum: int = last_score_deltas.reduce(sum, 0)
		
	if last_score_deltas_sum > score_to_expand:
		expand_timer.start()
	
	scale = lerp(Vector2.ONE * max_scale, Vector2.ONE, ease(1 - expand_timer.time_left / expand_timer.wait_time, 5))
	pivot_offset = size / 2
	
	text = str(Global.score)

func sum(accum, num):
	return accum + num
