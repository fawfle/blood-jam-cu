extends GPUParticles2D

func _ready() -> void:
	restart()
	# emitting = true
	finished.connect(_on_finish)

func _on_finish():
	queue_free()
