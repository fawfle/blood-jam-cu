extends Area2D

@export var speed: int = 100
var direction


func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# hurt player
		pass
	queue_free()
