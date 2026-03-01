class_name Ground extends Sprite2D

var blood_image: Image;
@export var blood_texture: ImageTexture

@export var blood_color: Color = Color(1, 0, 0, 1)

# var room_size: Vector2i = Vector2i(288, 162)

var updated_image: bool = false

func _init() -> void:
	Global.ground = self

func _ready() -> void:	
	blood_image = create_image(Global.room_size)
	blood_texture.set_image(blood_image)
	
	resize_room(Global.room_size)
	
	Global.room_resized.connect(resize_room)
	
	#for i in range(50):
	#	for j in range(50):
	#		paint_pixel(i, j)
	
	
	# (material as ShaderMaterial).set_shader_parameter("blood", blood_texture)

var filled_pixels: int = 0

func _process(delta: float) -> void:
	if updated_image:
		blood_texture.update(blood_image)
		updated_image = false

func resize_room(new_size: Vector2i):
	var new_image: Image = create_image(new_size)
	
	var x_offset: int = (new_image.get_width() - blood_image.get_width()) / 2
	var y_offset: int = (new_image.get_height() - blood_image.get_height()) / 2
	
	for x in range(blood_image.get_width()):
		for y in range(blood_image.get_height()):
			new_image.set_pixel(x + x_offset, y + y_offset, blood_image.get_pixel(x, y))
	
	blood_texture.set_image(new_image)
	blood_image = new_image
	
	texture.width = new_size.x
	texture.height = new_size.y
	
	# blood_texture.draw_rect(blood_texture, Rect2(1, 1, 1, 1), false)

func get_fill_ratio() -> float:
	return filled_pixels / (float)(Global.room_size.x * Global.room_size.y)

func paint_circle(circle_pos: Vector2i, radius: int) -> int:
	radius += 2
	circle_pos += Global.room_size / 2
	var painted_pixels = 0;
	var start_x: int = max(circle_pos.x - radius - 10, 0)
	var end_x: int = min(circle_pos.x + radius, Global.room_size.x)
	var start_y: int = max(circle_pos.y - radius - 10, 0)
	var end_y: int = min(circle_pos.y + radius, Global.room_size.y)
	
	for x in range(start_x, end_x):
		for y in range(start_y, end_y):
			# check if it's in circle
			var pos: Vector2i = Vector2i(x, y)
			var distance = circle_pos.distance_to(pos)
			var ignore_chance = 1 - pow((distance / radius), 3)
			
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
	if current_color.a != 0:
		return false
	
	blood_image.set_pixel(x, y, blood_color)
	updated_image = true
	return true

func is_pixel_filled(x: int, y: int) -> bool:
	if not is_in_image(x, y): return false
	var current_color = blood_image.get_pixel(x, y)
	return current_color.a != 0

func is_in_image(x: int, y: int) -> bool:
	if x < 0 or y < 0: return false
	if x >= Global.room_size.x or y >= Global.room_size.y: return false
	
	return true

func create_image(size: Vector2i) -> Image:
	var img: Image = Image.create_empty(size.x, size.y, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	return img
