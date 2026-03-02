class_name Wall extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape = $CollisionShape2D

@onready var background: Sprite2D = $Background

var wall_position: WallPosition

enum WallPosition {
	LEFT,
	RIGHT,
	TOP,
	BOTTOM
}

const BACKGROUND_SIZE: float = 20
const BACKGROUND_PADDING: float = 20
const WALL_WIDTH: float = 1

func set_wall_position(pos: Wall.WallPosition):
	wall_position = pos
	
	match(wall_position):
		WallPosition.LEFT:
			background.position = Vector2(-BACKGROUND_SIZE / 2, 0)
		WallPosition.RIGHT:
			background.position = Vector2(BACKGROUND_SIZE / 2, 0)
		WallPosition.TOP:
			background.position = Vector2(0, -BACKGROUND_SIZE / 2)
		WallPosition.BOTTOM:
			background.position = Vector2(0, BACKGROUND_SIZE / 2)

func update_to_room_size(room_size, duration: float = 0):
	var tween = create_tween()
	tween.set_parallel(true)
	
	var size: Vector2 = Vector2(room_size.x, WALL_WIDTH)
	if wall_position == WallPosition.LEFT or wall_position == WallPosition.RIGHT:
		size = Vector2(WALL_WIDTH, room_size.y)
	
	var rectangle_shape: RectangleShape2D = RectangleShape2D.new()
	rectangle_shape.size = size
	collision_shape.shape = rectangle_shape
	
	var target_region_rect: Rect2 = Rect2(Vector2.ZERO, size)
	var background_rect_size: Vector2
	var target_position: Vector2 = Vector2.ZERO
	
	# yeah this is bad, but idc
	match(wall_position):
		WallPosition.LEFT:
			target_position = Vector2(-room_size.x / 2.0 + WALL_WIDTH / 2, 0)
			background_rect_size = Vector2(BACKGROUND_SIZE, room_size.y + BACKGROUND_PADDING)
		WallPosition.RIGHT:
			target_position = Vector2(room_size.x / 2.0 - WALL_WIDTH / 2, 0)
			background_rect_size = Vector2(BACKGROUND_SIZE, room_size.y + BACKGROUND_PADDING)
		WallPosition.TOP:
			target_position = Vector2(0, -room_size.y / 2.0 + WALL_WIDTH / 2)
			background_rect_size = Vector2(room_size.x + BACKGROUND_PADDING, BACKGROUND_SIZE)
		WallPosition.BOTTOM:
			target_position = Vector2(0, room_size.y / 2.0 - WALL_WIDTH / 2)
			background_rect_size = Vector2(room_size.x + BACKGROUND_PADDING, BACKGROUND_SIZE)
	
	background.region_rect = Rect2(Vector2.ZERO, background_rect_size)
	
	tween.tween_property(sprite, "region_rect", target_region_rect, duration)
	tween.tween_property(self, "position", target_position, duration)

func is_vertical_wall():
	return wall_position == WallPosition.LEFT or wall_position == WallPosition.RIGHT
