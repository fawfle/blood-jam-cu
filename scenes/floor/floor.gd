extends Sprite2D

var blood_image: Image;
@export var blood_texture: ImageTexture

var room_size: Vector2i = Vector2i(288, 162)

func _ready() -> void:
	blood_image = Image.create(room_size.x, room_size.y, false, Image.FORMAT_RGBA8)
	blood_image.fill(Color(0, 0, 0, 0))
	blood_texture.set_image(blood_image)
	print(blood_texture)
	
	# (material as ShaderMaterial).set_shader_parameter("blood", blood_texture)

func _process(delta: float) -> void:
	pass
