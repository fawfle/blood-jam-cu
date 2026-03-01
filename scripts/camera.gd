extends Camera2D

@export var target: Node2D

const MARGIN = 4

var tween_time: float = 0.5

func _ready() -> void:
	Global.room_resized.connect(_on_room_resized)

func _process(delta: float) -> void:
	position = Vector2i(position)

func _on_room_resized(size: Vector2i):
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "limit_left", -size.x / 2 - MARGIN, tween_time)
	# limit_left = -size.x / 2 - MARGIN
	tween.tween_property(self, "limit_right", size.x / 2 + MARGIN, tween_time)
	tween.tween_property(self, "limit_top", -size.y / 2 - MARGIN, tween_time)
	tween.tween_property(self, "limit_bottom", size.y / 2 + MARGIN, tween_time)
