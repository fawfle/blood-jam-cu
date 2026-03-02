extends GPUParticles2D

func _ready() -> void:
	restart()
	# emitting = true
	finished.connect(_on_finish)

func _physics_process(_delta: float) -> void:
	var direction_2d: Vector2 = -Global.player.velocity.normalized()
	(process_material as ParticleProcessMaterial).direction = Vector3(direction_2d.x, direction_2d.y, 0)

func _on_finish():
	queue_free()
