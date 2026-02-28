class_name Player extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $SmallSprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var move_acceleration: float = 400.0
@export var stop_acceleration: float = 800.0
@export var max_speed: float = 500.0

@export var min_dash_speed: float = 200
## amount of previous speed to keep when dashing
@export var dash_multiplier: float = 0.2

## damping applied on bounce
@export var bounce_multiplier: float = 0.8
## min speed required to bounce
@export var min_speed_to_bounce: float = 80

@export var blood_scale: float = 10.0

@export var paint_cost: float = 0.01

@export var slowdown_per_pixel: float = 0.1

var size: float = 1

var last_movement_input: Vector2 = Vector2.RIGHT
var movement_input := Vector2.ZERO

enum Size {
	SMALL,
	MEDIUM,
	LARGE
}

var SPRITE_SIZES: Dictionary[Size, float] = {
	Size.SMALL: 13,
	Size.MEDIUM: 20,
	Size.LARGE: 15
}

func _init() -> void:
	Global.player = self

func _ready() -> void:
	animated_sprite.play()

func _physics_process(delta: float) -> void:
	update_size()
	
	handle_move(delta)
	paint_trail()
	
	# TODO: slow down based on painted pixels

func update_size():
	size = max(0, Global.blood) / blood_scale
	animated_sprite.scale = Vector2.ONE * size * 0.16
	animated_sprite.play("idle")
	(collision_shape.shape as CircleShape2D).radius = size
	

func paint_trail():
	var painted: int = Global.ground.paint_circle(global_position, round(size))
	# var prev_vel = velocity
	velocity = velocity.move_toward(Vector2.ZERO, painted * slowdown_per_pixel)
	Global.blood -= painted * paint_cost
	# if painted != 0: print(velocity - prev_vel)

func handle_move(delta):
	movement_input = Input.get_vector("left", "right", "forward", "backward")
	if movement_input != Vector2.ZERO: last_movement_input = movement_input
	
	var target_velocity: Vector2 = movement_input * max_speed
	var acceleration: float = move_acceleration if movement_input != Vector2.ZERO else stop_acceleration
	velocity = velocity.move_toward(target_velocity, acceleration * delta)
	
	if Input.is_action_just_pressed("dash"):
		dash()
	
	var previous_velocity: Vector2 = velocity
	move_and_slide()
	
	var collision := get_last_slide_collision()
	if collision != null:
		paint_trail()
		bounce(previous_velocity, collision)

func bounce(previous_velocity: Vector2, collision: KinematicCollision2D):
	if previous_velocity.length() < min_speed_to_bounce: return
	velocity = -previous_velocity.reflect(collision.get_normal()) * bounce_multiplier
	move_and_slide()

func dash() -> void:
	# use the last movement input for if player isn't holding a direction
	var dash_speed: float = max(velocity.length(), min_dash_speed)
	velocity = last_movement_input * dash_speed + (velocity * dash_multiplier)
