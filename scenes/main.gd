class_name Main extends Node2D

enum EnemyType {
	FODDER,
	SHOOTER,
	SHIELDED,
	JANITOR,
	DUCK,
	FLAMER
}

const wall_scene := preload("res://scenes/wall/wall.tscn")

var left_wall: Wall
var right_wall: Wall
var top_wall: Wall
var bottom_wall: Wall

@export var fill_ratio_target = 0.6

@export var room_scaling = 1.2

## "magic number to determine how hard the game is
var difficulty: float = 0

## number of times rooms resized
var resize_number: int = 0
## time it takes to spawn an enemy
var enemy_spawn_time: float = 2.0
## amount to vary spawn times by
var enemy_spawn_time_variation: float = 0.1
## at max difficulty, the amount of time it takes to spawn enemy
var max_enemy_spawn_time: float = enemy_spawn_time
var min_enemy_spawn_time: float = 0.7
var enemy_spawn_timer: float = 0.0

var game_over_scene: PackedScene = preload("res://scenes/game_over.tscn")

@onready var death_sound: AudioStreamPlayer2D = $DeathSound
@onready var teleport_sound: AudioStreamPlayer2D = $TeleportSound

var main_menu: PackedScene = preload("res://scenes/main_menu.tscn")
var fodder_scene: PackedScene = preload("res://scenes/enemies/fodder/fodder.tscn")
var shooter_scene: PackedScene = preload("res://scenes/enemies/shooter/shooter.tscn")
var shielded_scene: PackedScene = preload("res://scenes/enemies/shielded/shielded.tscn")
var janitor_scene: PackedScene = preload("res://scenes/enemies/janitor/janitor.tscn")
var duck_scene: PackedScene = preload("res://scenes/enemies/duck/duck.tscn")
var flamer_scene: PackedScene = preload("res://scenes/enemies/flamer/flamer.tscn")

var table_scene: PackedScene = preload("res://scenes/obstacles/table.tscn")

var enemy_teleport_scene: PackedScene = preload("res://scenes/enemies/teleport/enemy_teleport.tscn")

## pretend its constant lol. Map enemy type enums to scenes
var ENEMY_SCENES: Dictionary[EnemyType, PackedScene] = {
	EnemyType.FODDER: fodder_scene,
	EnemyType.SHOOTER: shooter_scene,
	EnemyType.SHIELDED: shielded_scene,
	EnemyType.JANITOR: janitor_scene,
	EnemyType.DUCK: duck_scene,
	EnemyType.FLAMER: flamer_scene
}

## map types to spawn rates
var enemy_spawn_rates: Dictionary[EnemyType, float] = {
	EnemyType.FODDER: 100,
	EnemyType.SHOOTER: 300,
	EnemyType.SHIELDED: 9075,
	EnemyType.JANITOR: 200,
	EnemyType.DUCK: 20,
	EnemyType.FLAMER: 100
}

func _init() -> void:
	Global.main = self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_wall = create_wall(Wall.WallPosition.LEFT)
	right_wall = create_wall(Wall.WallPosition.RIGHT)
	top_wall = create_wall(Wall.WallPosition.TOP)
	bottom_wall = create_wall(Wall.WallPosition.BOTTOM)
	update_walls(Global.room_size)
	
	Global.room_resized.emit(Global.start_room_size)
	Global.out_of_blood.connect(_on_death)
	Global.enemy_eaten.connect(_enemy_death)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	handle_fill()
	if Global.player.dead: return
	handle_spawning(delta)
	
	handle_difficulty()

func handle_difficulty():
	difficulty = resize_number * 50
	
	enemy_spawn_time = approach_from(max_enemy_spawn_time, min_enemy_spawn_time, 0.01, difficulty)

## amount to scale player blood by. Decreases as more enemies spawn to keep things balanced
func get_blood_scale() -> float:
	# print(lerpf(0.2, 1, enemy_spawn_time / max_enemy_spawn_time))
	return lerpf(0.3, 1, enemy_spawn_time / max_enemy_spawn_time)
	# return clamp(enemy_spawn_time / max_enemy_spawn_time * 1.4, 0.2, 1)

func handle_fill():
	var fill_ratio: float = Global.ground.get_fill_ratio()
	# print(fill_ratio)
	if fill_ratio == null or fill_ratio_target == null: return
	if fill_ratio > fill_ratio_target:
		resize_room()

func handle_spawning(delta: float):
	enemy_spawn_timer -= delta
	if enemy_spawn_timer <= 0:
		spawn_enemy()
		enemy_spawn_timer = enemy_spawn_time + randf() * enemy_spawn_time_variation

func spawn_enemy():
	var random_pos = Global.random_position_in_room_away_from_player()
	
	var enemy: Enemy =  get_random_enemy().instantiate()
	var teleport: EnemyTeleport = enemy_teleport_scene.instantiate()
	add_child(teleport)
	teleport.owner = self
	teleport.global_position = random_pos
	await teleport.animation_finished
	teleport_sound.play()
	add_child(enemy)
	enemy.owner = self
	enemy.global_position = random_pos

func get_random_enemy() -> PackedScene:
	var enemy_weight: float = get_enemy_spawn_weight_total()
	var rand_value: float = randf_range(0, enemy_weight)
	
	for key in enemy_spawn_rates.keys():
		rand_value -= enemy_spawn_rates.get(key)
		if rand_value <= 0:
			return ENEMY_SCENES.get(key)
	
	push_error("Get random enemy returned null. Should always find an enemy")
	return null

func resize_room():
	resize_number += 1
	var previous_room_size: Vector2i = Global.room_size
	Global.room_size *= room_scaling
	# force room size to be even
	Global.room_size = Vector2(floor(Global.room_size.x / 2) * 2, floor(Global.room_size.y / 2) * 2)
	update_walls(Global.room_size, 0.5)
	Global.room_resized.emit(Global.room_size)
	
	spawn_obstacles(previous_room_size, Global.room_size)

func spawn_obstacles(previous_room_size: Vector2i, room_size: Vector2i):
	var spawn_range: Vector2 = (room_size - previous_room_size) / 2 + Vector2i(20, 20)
	
	## spawn on left/right. if false, spawn on top/bottom
	var spawn_horizontal: bool = randf() > 0.5
	var spawn_position: Vector2
	
	print(spawn_range)
	
	if spawn_horizontal:
		spawn_position.x = (previous_room_size.x / 2.0 + spawn_range.x * randf()) * (-1 if randf() > 0.5 else 1)
		spawn_position.y = room_size.y / 2.0 * randf_range(-1, 1)
	else:
		spawn_position.x = room_size.x / 2.0 * randf_range(-1, 1)
		spawn_position.y = (previous_room_size.y / 2.0 + spawn_range.y * randf()) * (-1 if randf() > 0.5 else 1)
		
	var table: StaticBody2D = table_scene.instantiate()
	add_child(table)
	table.global_position = spawn_position
	table.rotation = randf() * PI * 2

const WALL_ANIMATION_TIME = 0.5

func update_walls(room_size: Vector2i, duration: float = 0):
	left_wall.update_to_room_size(room_size, duration)
	right_wall.update_to_room_size(room_size, duration)
	top_wall.update_to_room_size(room_size, duration)
	bottom_wall.update_to_room_size(room_size, duration)

func create_wall(pos: Wall.WallPosition) -> Wall:
	var wall: Wall = wall_scene.instantiate()
	add_child(wall)
	wall.set_wall_position(pos)
	return wall

func get_enemy_spawn_weight_total() -> float:
	var total_weight: float = 0.0
	for value in enemy_spawn_rates.values():
		total_weight += value
	
	return total_weight

func _on_death() -> void:
	var game_over := game_over_scene.instantiate()
	add_child(game_over)

func _enemy_death(enemy: Enemy) -> void:
	death_sound.play(0.2)
	# add blood here so we can scale it
	Global.blood += enemy.blood * get_blood_scale()

const E = 2.71828

func approach(max_val: float, k: float, x: float) -> float:
	var ret: float = 1.0 / (1 + pow(E, -k * x)) - 0.5
	ret *= 2 * max_val
	return ret

func approach_from(start: float, end: float, k: float, x: float) -> float:
	return start + approach(end - start, k, x)
