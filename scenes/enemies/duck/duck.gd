extends Enemy

@onready var animated_sprite = $AnimatedSprite2D
@onready var area_collision_shape = $Area2D/CollisionShape2D
@onready var body_collision_shape = $CollisionShape2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var flame_pivot: Node2D = $FlamePivot

var flame_scene: PackedScene = preload("res://scenes/enemies/flame/Flame.tscn")
var projectile_scene: PackedScene = preload("res://scenes/enemies/projectile/projectile.tscn")

var is_flaming = false
var flame: Flame
var flame_distance: float = 100

@export var rotation_speed: float = 0.5

var run_distance: float = 50

var elite_scale: float = 2

func _on_ready() -> void:
	blood_color = Color(0.78, 0.387, 0.0, 1.0)

func choose_animation() -> void:
	if velocity == Vector2.ZERO:
		animated_sprite.play("idle")
	elif velocity.x > 0:
		animated_sprite.flip_h = true
		animated_sprite.play("run_side")
	elif velocity.x < 0:
		animated_sprite.flip_h = false
		animated_sprite.play("run_side")
		
func find_direction() -> void:
	if position.distance_to(player.position) < run_distance:
		move_in_direction = false
		direction = -position.direction_to(player.position)
	else:
		if not move_in_direction:
			direction = Vector2.from_angle(randf() * PI * 2)
			move_in_direction_until(0.5)

func _on_shoot_timer_timeout():
	if elite:
		if position.distance_to(player.global_position) < flame_distance:
			start_flaming()
		else:
			stop_flaming()
			create_projectile_in_direction(global_position.direction_to(player.global_position))

## straight copied and pasted
func _on_physics_process(delta: float):
	if flame == null: return
	
	var angle_to_player: float = flame_pivot.get_angle_to(Global.player.global_position)
	var rotate_angle: float = max(abs(angle_to_player), rotation_speed) * sign(angle_to_player)
	
	flame_pivot.rotate(rotate_angle * delta)
	flame.animated_sprite.flip_h = abs(flame_pivot.rotation_degrees) > PI / 2

func start_flaming() -> void:
	if is_flaming: return
	is_flaming = true
	
	flame = create_flame(Vector2(24, 0))
	flame_pivot.look_at(Global.player.global_position)

func create_flame(offset: Vector2):
	var f: Flame = flame_scene.instantiate()
	# fixed offset
	f.position = offset
	# flame_pivot.rotation = dir.angle()
	flame_pivot.add_child(f)
	f.owner = flame_pivot
	return f

func stop_flaming() -> void:
	if not is_flaming: return
	is_flaming = false
	flame.queue_free()
	flame = null

## copy and pasting :)
func create_projectile_in_direction(dir: Vector2):
	var projectile: Area2D = projectile_scene.instantiate()
	projectile.direction = dir
	projectile.global_position = global_position
	projectile.rotation = dir.angle()
	if owner: owner.add_child(projectile)
	else: get_tree().add_child(projectile)

func on_elite_changed():
	animated_sprite.scale = Vector2.ONE * elite_scale
	## i love magic numbers. Just the scale in inspector hardcoded
	area_collision_shape.shape.radius = 5 * elite_scale
	body_collision_shape.shape.radius = 6 * elite_scale
	
	shoot_timer.start()
