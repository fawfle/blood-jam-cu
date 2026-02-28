extends Node2D

const wall_scene := preload("res://scenes/wall/wall.tscn")

var left_wall: Wall
var right_wall: Wall
var top_wall: Wall
var bottom_wall: Wall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_wall = create_wall()
	right_wall = create_wall()
	top_wall = create_wall()
	bottom_wall = create_wall()
	update_wall(left_wall)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_wall(wall: Wall):
	wall.update_size(Vector2(268, 10))
	wall.global_position = Vector2(0, 142)

func create_wall() -> Wall:
	var wall: Wall = wall_scene.instantiate()
	add_child(wall)
	return wall
