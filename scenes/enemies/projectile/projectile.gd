extends Area2D

@export var speed: int
var direction


func _physics_process(delta: float) -> void:
	var velocity: int = direction * speed
	position += direction * velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# damage player blood
		pass
	queue_free()
