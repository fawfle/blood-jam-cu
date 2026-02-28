class_name Enemy

extends CharacterBody2D

@export var speed: int = 100
@export var blood: int = 100
var player = get_tree().get_root().get_node("res://scenes/player/player.tscn")
var direction: Vector2 = Vector2.ZERO

func find_direction() -> void:
	pass

func _physics_process(_delta: float) -> void:
	find_direction()
	velocity = direction * speed
	move_and_slide()
