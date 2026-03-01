class_name Main extends Node2D

const wall_scene := preload("res://scenes/wall/wall.tscn")

var left_wall: Wall
var right_wall: Wall
var top_wall: Wall
var bottom_wall: Wall

@export var fill_ratio_target = 0.6

@export var room_scaling = 1.2

var wave: int = 1
var enemy_spawn_time: float = 4
var enemy_spawn_timer: float = 0.0

var fodder_scene: PackedScene = preload("res://scenes/enemies/fodder/fodder.tscn")
var shooter_scene: PackedScene = preload("res://scenes/enemies/shooter/shooter.tscn")

const WALL_WIDTH: float = 1

func _init() -> void:
	Global.main = self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_wall = create_wall()
	right_wall = create_wall()
	top_wall = create_wall()
	bottom_wall = create_wall()
	update_walls(Global.room_size)
	
	Global.room_resized.emit(Global.room_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_fill()
	
	handle_spawning(delta)

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
	var random_pos = Global.random_position_in_room()
	var enemy: Enemy = fodder_scene.instantiate()
	add_child(enemy)
	enemy.global_position = random_pos

func resize_room():
	wave += 1
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
