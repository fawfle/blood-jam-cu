extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@export var damage: float = 0.5
const BURNT_BLOOD_COLOR = Color("1D0200")
var flamer
var burning_player = false

func _ready() -> void:
	animated_sprite.play("fire_start")
	animated_sprite.play("fire_last")
	

func _physics_process(_delta: float) -> void:
	if flamer.animated_sprite.flip_h:
		animated_sprite.flip_h = true
		position = flamer.position + Vector2(-8,-2)
	else:
		animated_sprite.flip_h = false
		position = flamer.position - Vector2(24,2)
	if burning_player: 
		Global.blood -= damage 
		Global.ground.paint_circle_color(Global.player.position, randi_range(6,6), BURNT_BLOOD_COLOR, true)
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		burning_player = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		burning_player = false
