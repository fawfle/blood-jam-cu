class_name Wall extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func update_size(size: Vector2):
	var rectangle_shape: RectangleShape2D = RectangleShape2D.new()
	rectangle_shape.size = size
	collision_shape.shape = rectangle_shape
	
	sprite.region_rect = Rect2(Vector2.ZERO, size)
