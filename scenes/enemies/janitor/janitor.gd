extends Enemy

@export var small_clean_radius: int = 8
@export var clean_radius: int = 15
@onready var clean_node: Node2D = $CleanNode
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var clean_threshold = 1

## speed at start
var start_speed: float
@export var clean_speed: float = 4

var cleaning: bool = false

func _on_ready():
	start_speed = speed

func _on_physics_process(_delta: float):
	clean_blood()
	speed = clean_speed if cleaning else start_speed

func choose_animation() -> void:
	if cleaning:
		animated_sprite.play("idle")
	elif velocity.x > 0 && velocity.x > velocity.y:
		animated_sprite.flip_h = true
		if animated_sprite.animation != "movement":
			animated_sprite.play("movement")
	elif velocity.x < 0 && velocity.x > velocity.y:
		animated_sprite.flip_h = false
		if animated_sprite.animation != "movement":
			animated_sprite.play("movement")
	
	animated_sprite.flip_h = velocity.x > 0

func find_direction() -> void:
	# var enemy_position: Vector2 = position
	# var player_position: Vector2 = player.position
	# direction = enemy_position.direction_to(player_position)
	if cleaning and not move_in_direction:
		move_in_direction_until(0.5)
		start_panicking(4.0)
	else:
		direction = position.direction_to(Global.player.global_position)

func clean_blood() -> void:
	if Global.ground == null: return
	
	var clean_position = global_position + clean_node.position * (Vector2(-1, 1) if animated_sprite.flip_h else Vector2(1, 1))
	var current_clean_radius = clean_radius if cleaning else small_clean_radius
	var painted: int = Global.ground.clear_circle(clean_position, current_clean_radius)
	
	if painted > clean_threshold:
		cleaning = true
	else:
		cleaning = false
