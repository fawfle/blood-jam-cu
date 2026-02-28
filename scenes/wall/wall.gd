class_name Wall extends StaticBody2D

@onready var collision_shape = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func update_size(size: Vector2):
	(collision_shape.shape as RectangleShape2D).size = size
	$Sprite2D.region_rect = Rect2(Vector2.ZERO, size)
