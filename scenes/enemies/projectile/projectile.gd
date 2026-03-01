extends Area2D

@export var damage: float = 20.0
@export var speed: int = 100

var direction: Vector2

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.blood -= damage	
	queue_free()
