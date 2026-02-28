extends CharacterBody2D

@export var speed := 200.0
@export var dash_multiplier := 10.0
var movement_input := Vector2.ZERO

func _physics_process(delta: float) -> void:
	#velocity = Vector3(movement_input.x,0,movement_input.y) * base_speed
	move_logic(delta)
	move_and_slide()

func move_logic(delta) -> void:
	movement_input = Input.get_vector("left", "right", "forward", "backward")
	var vel_2d = Vector2(velocity.x, velocity.y)
	if movement_input != Vector2.ZERO:
		vel_2d += movement_input * speed * delta
		vel_2d = vel_2d.limit_length(speed)
		velocity.x = vel_2d.x
		velocity.y = vel_2d.y
	else:
		vel_2d = vel_2d.move_toward(Vector2.ZERO, speed * 4.0 * delta)
		velocity.x = vel_2d.x
		velocity.y = vel_2d.y
	if Input.is_action_just_pressed("dash"):
		dash_logic(vel_2d)
	if is_on_wall():
		vel_2d = vel_2d.bounce() * speed
		velocity.x = vel_2d.x
		velocity.y = vel_2d.y

func dash_logic(vel_2d) -> void:
	print("Input read")
	movement_input = Input.get_vector("left", "right", "forward", "backward")
	vel_2d = movement_input * vel_2d.length() * dash_multiplier
	velocity.x = vel_2d.x
	velocity.y = vel_2d.y
	
