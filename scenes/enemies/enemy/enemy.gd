class_name Enemy

extends CharacterBody2D

@export var speed: int = 20
@export var blood: int = 20
var player = Global.player
var direction: Vector2 = Vector2.ZERO

@onready var area: Area2D = $Area2D 

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)

func find_direction() -> void:
	pass

func choose_animation() -> void:
	pass

func _physics_process(_delta: float) -> void:
	find_direction()
	choose_animation()
	velocity = direction * speed
	move_and_slide()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.blood += blood
		Global.enemy_eaten.emit(self)
		if Global.ground: Global.ground.paint_circle(global_position, 5)
		queue_free()
