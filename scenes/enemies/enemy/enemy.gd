class_name Enemy

extends CharacterBody2D

@export var speed: int = 20
@export var blood: int = 20
var player = Global.player
var direction: Vector2 = Vector2.ZERO

@onready var area: Area2D = $Area2D 

const blood_color = Color(0.631, 0.0, 0.0, 1.0)

var dead: bool = false

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
		die()

func die():
	dead = true
	await move_towards_player()
	if not dead: return
	
	Global.blood += blood
	Global.enemy_eaten.emit(self)
	process_mode = Node.PROCESS_MODE_DISABLED
	if Global.ground: Global.ground.paint_circle_color(global_position, randi_range(4,6), blood_color, true)
	
	queue_free()

## played on death
func move_towards_player() -> void:
	var move_toward_speed = 600.0
	
	while global_position.distance_to(Global.player.global_position) > max(Global.player.size - 4, 0):
		var speed_delta: float = move_toward_speed * get_physics_process_delta_time()
		move_toward_speed *= 1.1
		position = global_position.move_toward(Global.player.global_position, speed_delta)
		await get_tree().physics_frame
		if global_position.distance_to(Global.player.global_position) > Global.player.size + 4:
			dead = false
			break
	
