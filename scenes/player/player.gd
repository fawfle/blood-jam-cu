class_name Player extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var eat_collision_shape: CollisionShape2D = $EatArea/CollisionShape2D
@onready var movement_sound: AudioStreamPlayer2D = $MovementSound
@onready var bounce_sound: AudioStreamPlayer2D = $BounceSound
@onready var dash_sound: AudioStreamPlayer2D = $DashSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

@onready var trail_particles: GPUParticles2D = $TrailParticles
var dash_particles_scene: PackedScene = preload("res://scenes/player/dash_particles.tscn")

@export var move_acceleration: float = 400.0
@export var stop_acceleration: float = 800.0
@export var max_speed: float = 500.0

@export var min_dash_speed: float = 200
## amount of previous speed to keep when dashing
@export var dash_multiplier: float = 0.2

## damping applied on bounce
@export var bounce_multiplier: float = 0.7
## min speed required to bounce
@export var min_speed_to_bounce: float = 80
@export var bounce_cost: float = 1.0

@export var blood_scale: float = 10.0

@export var bleed_per_second: float = 5
@export var bleed_per_second_small: float = 3.0
@export var small_threshold: float = 3.5

@export var dash_cost: float = 2.5
@export var paint_cost: float = 0.0025

@export var slowdown_per_pixel: float = 0.05

var size: float = 1

var dead: bool = false

var can_dash: bool = true

var last_movement_input: Vector2 = Vector2.RIGHT
var movement_input := Vector2.ZERO

const MAX_SIZE: float = 40

func _init() -> void:
	Global.player = self

func _ready() -> void:
	animated_sprite.play("big_idle")
	trail_particles.emitting = true
	Global.out_of_blood.connect(_on_out_of_blood)
	update_size()

func _physics_process(delta: float) -> void:
	if SceneManager.transitioning: return
	
	if dead:
		velocity = velocity.move_toward(Vector2.ZERO, move_acceleration * delta)
		move_and_slide()
		return
	
	if size < small_threshold: Global.blood -= bleed_per_second_small * delta
	else: Global.blood -= bleed_per_second * delta
	
	update_size()
	
	handle_move(delta)
	paint_trail(global_position, size)
	
	update_animation()
	
	## call after updating blood 100%
	if Global.blood <= 0:
		Global.out_of_blood.emit()

func update_animation():
	var play_speed: float = velocity.length() / 100.0 + 0.1
	if movement_input.x != 0:
		animated_sprite.play("big_move", play_speed)
		play_movement_sound()
	elif movement_input.y != 0:
		if movement_input.y > 0: animated_sprite.play("big_move_vertical", play_speed)
		else: animated_sprite.play("big_move_vertical", -play_speed)
		play_movement_sound()
	else:
		animated_sprite.play("big_idle")
		movement_sound.stop()
	if movement_input.x != 0:
		animated_sprite.flip_h = movement_input.x > 0
	
	# update particles
	trail_particles.process_material.gravity = Vector3(-velocity.normalized().x, -velocity.normalized().y, 0)

func update_size():
	size = max(0, Global.blood) / blood_scale
	size = min(size, MAX_SIZE)
	animated_sprite.scale = Vector2.ONE * size * 0.055
	(collision_shape.shape as CircleShape2D).radius = size
	(eat_collision_shape.shape as CircleShape2D).radius = max(2, size)
	trail_particles.position.y = size
	trail_particles.process_material.emission_box_extents.x = max(1, size - 6)
	trail_particles.amount_ratio = lerp(0.20, 1.0, size / MAX_SIZE)

func paint_trail(pos: Vector2, trail_size: float):
	if Global.ground == null: return
	var painted: int = Global.ground.paint_circle(pos, round(trail_size))
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
		Global.score += 1
		dash()
	
	var previous_velocity: Vector2 = velocity
	move_and_slide()
	
	var collision := get_last_slide_collision()
	if collision != null:
		# when hitting wall, splatter self
		paint_trail(global_position + (size / 2 * previous_velocity.normalized()), size + previous_velocity.length() / 50)
		bounce(previous_velocity, collision)

func bounce(previous_velocity: Vector2, collision: KinematicCollision2D):
	if previous_velocity.length() < min_speed_to_bounce: return
	velocity = -previous_velocity.reflect(collision.get_normal()) * bounce_multiplier
	Global.blood -= bounce_cost
	bounce_sound.play()
	move_and_slide()
	try_to_bloody_collider(previous_velocity, collision)

func try_to_bloody_collider(previous_velocity: Vector2, collision: KinematicCollision2D):
	if collision.get_collider_shape() is SpriteCollisionShape:
		var shape: SpriteCollisionShape = collision.get_collider_shape() as SpriteCollisionShape
		
		var blood_sprite = Sprite2D.new()
		shape.sprite.add_child(blood_sprite)
		var radius: float = size + previous_velocity.length() / 50
		blood_sprite.texture = TextureHelper.create_circle_texture(radius, Global.ground.blood_color, Global.ground.blood_color_alt)
		blood_sprite.global_position = collision.get_position()

func dash() -> void:
	# use the last movement input for if player isn't holding a direction
	var dash_speed: float = max(velocity.length(), min_dash_speed)
	velocity = last_movement_input * dash_speed + (velocity * dash_multiplier)
	Global.blood -= dash_cost
	dash_sound.play()
	
	var dash_particles: GPUParticles2D = dash_particles_scene.instantiate()
	add_child(dash_particles)
	
func play_movement_sound() -> void:
	if movement_sound.playing == false:
		movement_sound.play(15)

func _on_out_of_blood():
	dead = true
	# collision_shape.disabled = true
	eat_collision_shape.disabled = true
	trail_particles.emitting = false
	death_sound.play(0.2)
	#set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
