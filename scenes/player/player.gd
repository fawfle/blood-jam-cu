class_name Player extends CharacterBody2D

@export var move_acceleration: float = 400.0
@export var stop_acceleration: float = 800.0
@export var max_speed: float = 500.0

@export var min_dash_speed: float = 200
## amount of previous speed to keep when dashing
@export var dash_multiplier: float = 0.2

## damping applied on bounce
@export var bounce_multiplier: float = 0.8

@export var blood_scale: float = 10.0

@export var slowdown_per_pixel: float = 1000

var size: float = 1

var last_movement_input: Vector2 = Vector2.RIGHT
var movement_input := Vector2.ZERO

func _init() -> void:
	Global.player = self

func _physics_process(delta: float) -> void:
	update_size()
	
	handle_move(delta)
	var painted: int = Global.ground.paint_circle(global_position, round(size))
	if painted != 0: print(painted)
	velocity.move_toward(Vector2.ZERO, painted * slowdown_per_pixel)
	# TODO: slow down based on painted pixels

func update_size():
	size = Global.blood / blood_scale

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
	if collision != null: bounce(previous_velocity, collision)

func bounce(previous_velocity: Vector2, collision: KinematicCollision2D):
	velocity = -previous_velocity.reflect(collision.get_normal()) * bounce_multiplier
	print(velocity)
	move_and_slide()

func dash() -> void:
	# use the last movement input for if player isn't holding a direction
	var dash_speed: float = max(velocity.length(), min_dash_speed)
	velocity = last_movement_input * dash_speed + (velocity * dash_multiplier)
