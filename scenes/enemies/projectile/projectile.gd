extends Area2D

@export var damage: float = 20.0
@export var speed: int = 100
@export var knockback_force: float = 100

var direction: Vector2
const SHOT_BLOD_COLOR = Color(0.441, 0.071, 0.022, 1.0)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.blood -= damage
		Global.player.velocity += direction * knockback_force
		Global.ground.paint_circle_color(global_position, randi_range(6,6), SHOT_BLOD_COLOR, true)
	queue_free()
