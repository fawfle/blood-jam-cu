class_name DissapearSprite extends Sprite2D

func disapear_after(duration: float, fade: bool =true):
	if fade:
		var tween: Tween = create_tween()
		tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), duration)
	
	await get_tree().create_timer(duration).timeout
	
	queue_free()
