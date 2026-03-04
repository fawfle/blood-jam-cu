extends Camera2D

@export var target: Node2D

const MARGIN = 2

var tween_time: float = 0.5

var shake_time: float = 0
var shake_power: float = 0.0

func _ready() -> void:
	Global.room_resized.connect(_on_room_resized)

func _process(delta: float) -> void:
	if shake_time > 0:
		shake_screen_process(delta)

func _on_room_resized(size: Vector2i):
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "limit_left", floor(-size.x / 2 - MARGIN), tween_time)
	# limit_left = -size.x / 2 - MARGIN
	tween.tween_property(self, "limit_right", floor(size.x / 2 + MARGIN), tween_time)
	tween.tween_property(self, "limit_top", floor(-size.y / 2 - MARGIN), tween_time)
	tween.tween_property(self, "limit_bottom", floor(size.y / 2 + MARGIN), tween_time)

func shake_screen_process(delta):
	shake_time -= delta
	offset.x = shake_power * randf_range(-1, 1)
	offset.y = shake_power * randf_range(-1, 1)
