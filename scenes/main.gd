extends Node2D

const wall_scene := preload("res://scenes/wall/wall.tscn")

var left_wall: Wall
var right_wall: Wall
var top_wall: Wall
var bottom_wall: Wall

const WALL_WIDTH: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_wall = create_wall()
	right_wall = create_wall()
	top_wall = create_wall()
	bottom_wall = create_wall()
	update_walls(get_viewport_rect().size - Vector2(2, 2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_walls(room_size: Vector2i):
	left_wall.global_position = Vector2(-room_size.x / 2.0 + WALL_WIDTH / 2, 0)
	right_wall.global_position = Vector2(room_size.x / 2.0 - WALL_WIDTH / 2, 0)
	top_wall.global_position = Vector2(0, -room_size.y / 2.0 + WALL_WIDTH / 2)
	bottom_wall.global_position = Vector2(0, room_size.y / 2.0 - WALL_WIDTH / 2)
	left_wall.update_size(Vector2(WALL_WIDTH, room_size.y))
	right_wall.update_size(Vector2(WALL_WIDTH, room_size.y))
	top_wall.update_size(Vector2(room_size.x, WALL_WIDTH))
	bottom_wall.update_size(Vector2(room_size.x, WALL_WIDTH))
	
	print(left_wall.global_position)
	print(right_wall.global_position)

func create_wall() -> Wall:
	var wall: Wall = wall_scene.instantiate()
	add_child(wall)
	return wall
