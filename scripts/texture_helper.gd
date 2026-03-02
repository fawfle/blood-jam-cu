class_name TextureHelper extends Node

## losing the plot here, copying and pasting is based

static func create_circle_texture(radius: int, color: Color, alt_color: Color = Color(0, 0, 0, 0)) -> ImageTexture:
	var image: Image = create_circle_image(radius, color, alt_color)
	return ImageTexture.create_from_image(image)


static func create_circle_image(radius: int, color: Color, alt_color: Color = Color(0, 0, 0, 0)) -> Image:
	var image: Image = create_image(Vector2i(radius * 2, radius * 2))
	paint_circle(image, radius, color, alt_color)
	return image

static func create_image(size: Vector2i) -> Image:
	var img: Image = Image.create_empty(size.x, size.y, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	return img


static func paint_circle(image: Image, radius: int, color: Color, alt_color: Color = Color(0, 0, 0, 0)) -> void:
	var circle_center: Vector2 = Vector2(radius, radius)
	for x in range(0, radius * 2):
		for y in range(0, radius * 2):
			# check if it's in circle
			var pos: Vector2i = Vector2i(x, y)
			var distance = circle_center.distance_to(pos)
			var ignore_chance = 1 - pow((distance / radius), 2)
			
			if distance < radius and randf() < ignore_chance:
				# random chance to not paint based on distance
				var c = color;
				if alt_color.a != 0.0: c = lerp(color, alt_color, randf())
				image.set_pixel(x, y, c)
