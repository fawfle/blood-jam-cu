class_name Enemy

extends CharacterBody2D

@export var speed: float = 20
@export var blood: int = 10
var player = Global.player
var direction: Vector2 = Vector2.ZERO

var panicking: bool = false
var move_in_direction: bool = false

var _panic_timer: float = 0
var _panic_timer_duration: float = 1.0
var move_in_direction_timer: float = 0
var move_in_direction_duration: float = 0.4

@onready var area: Area2D = $Area2D 
# var death_sound: PackedScene = preload("res://scenes/enemies/Sounds/death_sound.tscn")
var death_particles_scene: PackedScene = preload("res://scenes/particles/enemy_death_particles.tscn")

var blood_color = Color(0.631, 0.0, 0.0, 1.0)

var dying: bool = false

func _ready() -> void:
	add_to_group("enemies")
	area.area_entered.connect(_on_area_entered)
	_on_ready()
	
#func _init() -> void:
	#var sound_instance = death_sound.instantiate()
	#add_child(sound_instance)

## called on ready but doesn't override
func _on_ready():
	pass

## called 
func _on_physics_process(_delta: float):
	pass

func find_direction() -> void:
	pass

func choose_animation() -> void:
	pass

func _physics_process(delta: float) -> void:
	if dying: return
	if panicking:
		_panic_process(delta)
		_on_physics_process(delta)
		return
	
	if move_in_direction:
		move_in_direction_until_process(delta)
	else:
		find_direction()
	
	_on_physics_process(delta)
	choose_animation()
	velocity = direction * speed
	move_and_slide()
	
	var collision := get_last_slide_collision()
	if collision:
		start_panicking()

func _panic_process(delta: float) -> void:
	_panic_timer -= delta
	if _panic_timer <= 0:
		panicking = false
		return
		
	move_in_direction_until_process(delta)
	if not move_in_direction:
		move_in_direction_until(move_in_direction_duration + randf() * 0.2)
		
	velocity = direction * speed
	choose_animation()
	move_and_slide()

func move_in_direction_until_process(delta: float) -> void:
	move_in_direction_timer -= delta
	if move_in_direction_timer <= 0 or get_last_slide_collision() != null:
		move_in_direction = false
		return
	
	velocity = direction * speed

func start_panicking(time: float = _panic_timer_duration):
	panicking = true
	_panic_timer = time

func move_in_direction_until(duration: float):
	move_in_direction = true
	move_in_direction_timer = duration
	direction = Vector2.from_angle(randf() * PI * 2)

func _on_area_entered(entered_area: Node2D) -> void:
	if entered_area.is_in_group("player"):
		remove_from_group("enemies")
		die()

func die():
	dying = true
	set_shields(false)
	#await move_towards_player()
	#if not dying:
	#	set_shields(true)
	#	return
	## blood and stuff gets handled here
	Global.enemy_eaten.emit(self)
	#set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	if Global.ground: Global.ground.paint_circle_color(global_position, randi_range(6,6), blood_color, true)
	#set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	
	var death_particles: GPUParticles2D = death_particles_scene.instantiate()
	Global.player.add_child(death_particles)
	death_particles.global_position = global_position
	
	queue_free()

## played on death. UNUSED now
#func move_towards_player() -> void:
#	var move_toward_speed = 600.0
#	
#	while global_position.distance_to(Global.player.global_position) > max(Global.player.size - 1, 4):
#		var speed_delta: float = move_toward_speed * get_physics_process_delta_time()
#		move_toward_speed *= 1.5
#		position = global_position.move_toward(Global.player.global_position, speed_delta)
#		await get_tree().physics_frame
#		if global_position.distance_to(Global.player.global_position) > Global.player.size + 4:
#			dying = false
#			break
	

func set_shields(enabled: bool):
	var children := get_children()
	
	for child in children:
		if child.is_in_group("shield"):
			(child as Shield).set_enabled(enabled)
