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
var resize_number: int = 1
var enemy_spawn_time: float = 3
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

var enemy_teleport_scene: PackedScene = preload("res://scenes/enemies/teleport/enemy_teleport.tscn")

const WALL_WIDTH: float = 1

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
	EnemyType.SHOOTER: 200,
	EnemyType.SHIELDED: 300,
	EnemyType.JANITOR: 400,
	EnemyType.DUCK: 5,
	EnemyType.FLAMER: 0
}

func _init() -> void:
	Global.main = self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_wall = create_wall()
	right_wall = create_wall()
	top_wall = create_wall()
	bottom_wall = create_wall()
	update_walls(Global.room_size)
	
	Global.room_resized.emit(Global.start_room_size)
	Global.out_of_blood.connect(_on_death)
	Global.enemy_eaten.connect(_enemy_death)
	Global.blood = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_fill()
	handle_spawning(delta)
	
	handle_difficulty()

func handle_difficulty():
	difficulty = resize_number * 50

func handle_fill():
	var fill_ratio: float = Global.ground.get_fill_ratio()
	# print(fill_ratio)
	if fill_ratio > fill_ratio_target:
		resize_room()

func handle_spawning(delta: float):
	enemy_spawn_timer += delta
	if enemy_spawn_timer > enemy_spawn_time:
		spawn_enemy()
		enemy_spawn_timer = 0

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
	Global.room_size *= room_scaling
	update_walls(Global.room_size)
	Global.room_resized.emit(Global.room_size)

func update_walls(room_size: Vector2i):
	left_wall.global_position = Vector2(-room_size.x / 2.0 + WALL_WIDTH / 2, 0)
	right_wall.global_position = Vector2(room_size.x / 2.0 - WALL_WIDTH / 2, 0)
	top_wall.global_position = Vector2(0, -room_size.y / 2.0 + WALL_WIDTH / 2)
	bottom_wall.global_position = Vector2(0, room_size.y / 2.0 - WALL_WIDTH / 2)
	left_wall.update_size(Vector2(WALL_WIDTH, room_size.y))
	right_wall.update_size(Vector2(WALL_WIDTH, room_size.y))
	top_wall.update_size(Vector2(room_size.x, WALL_WIDTH))
	bottom_wall.update_size(Vector2(room_size.x, WALL_WIDTH))

func create_wall() -> Wall:
	var wall: Wall = wall_scene.instantiate()
	add_child(wall)
	return wall

func get_enemy_spawn_weight_total() -> float:
	var total_weight: float = 0.0
	for value in enemy_spawn_rates.values():
		total_weight += value
	
	return total_weight

func _on_death() -> void:
	var game_over := game_over_scene.instantiate()
	add_child(game_over)

func _enemy_death(_enemy: Enemy) -> void:
	death_sound.play(0.2)
