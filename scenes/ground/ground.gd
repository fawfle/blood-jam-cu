class_name Ground extends Sprite2D

var blood_image: Image;
@export var blood_texture: ImageTexture

var room_size: Vector2i = Vector2i(288, 162)

func _init() -> void:
	Global.ground = self

func _ready() -> void:
	blood_image = Image.create(room_size.x, room_size.y, false, Image.FORMAT_RGBA8)
	blood_image.fill(Color(0, 0, 0, 0))
	blood_texture.set_image(blood_image)
	
	#for i in range(50):
	#	for j in range(50):
	#		paint_pixel(i, j)
	
	
	# (material as ShaderMaterial).set_shader_parameter("blood", blood_texture)

func paint_circle(circle_pos: Vector2i, radius: int) -> int:
	circle_pos += room_size / 2
	var painted_pixels = 0;
	var start_x: int = max(circle_pos.x - radius, 0)
	var end_x: int = min(circle_pos.x + radius, room_size.x)
	var start_y: int = max(circle_pos.y - radius, 0)
	var end_y: int = min(circle_pos.y + radius, room_size.y)
	
	for x in range(start_x, end_x):
		for y in range(start_y, end_y):
			# check if it's in circle
			var pos: Vector2i = Vector2i(x, y)
			var distance = circle_pos.distance_to(pos)
			var ignore_chance = 1 - pow((distance / radius), 5)
			
			if distance < radius and randf() < ignore_chance:
				# random chance to not paint based on distance
				var painted: bool = paint_pixel(x, y);
				if painted: painted_pixels += 1;
	
	return painted_pixels;

func is_in_circle(circle_pos: Vector2i, radius: int, pos: Vector2i) -> bool:
	print(circle_pos.distance_to(pos))
	return circle_pos.distance_to(pos) < radius
	

func paint_pixel(x: int, y: int) -> bool:
	if not is_in_image(x, y): return false
	
	var current_color = blood_image.get_pixel(x, y)
	if current_color == Color(1, 1, 1, 1): return false
	
	blood_image.set_pixel(x, y, Color(1, 0, 0, 1))
	blood_texture.set_image(blood_image)
	return true

func is_in_image(x: int, y: int) -> bool:
	if x < 0 or y < 0: return false
	if x >= room_size.x or y >= room_size.y: return false
	
	return true
