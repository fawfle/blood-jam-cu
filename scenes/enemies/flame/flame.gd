class_name Flame extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var initial_damage: float = 10.0
@export var damage: float = 30.0
const BURNT_BLOOD_COLOR = Color("1D0200")
const BURNT_BLOOD_COLOR_ALT = Color("280200ff")

var burning_player = false

func _ready() -> void:
	animated_sprite.play("fire_start")
	animated_sprite.play("fire_last")
	

func _physics_process(delta: float) -> void:
	if burning_player:
		Global.blood -= damage * delta
		Global.ground.paint_circle_color(Global.player.global_position, Global.player.size, lerp(BURNT_BLOOD_COLOR, BURNT_BLOOD_COLOR_ALT, randf()), true)
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		burning_player = true
		Global.blood -= initial_damage

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		burning_player = false
