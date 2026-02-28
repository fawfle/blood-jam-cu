class_name Enemy

extends CharacterBody2D

@export var speed: int = 20
@export var blood: int = 20
var player = Global.player
var direction: Vector2 = Vector2.ZERO

func find_direction() -> void:
	pass

func _physics_process(_delta: float) -> void:
	find_direction()
	velocity = direction * speed
	move_and_slide()
	
func _on_collision_shape_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		queue_free()
