extends Area2D

@export var damage: float = 20.0
@export var speed: int = 100
@export var knockback_force: float = 150

var direction: Vector2
const INNER_SHOT_BLOOD_COLOR: Color  = Color(1.0, 1.0, 1.0, 1.0)
const OUTER_SHOT_BLOOD_COLOR: Color = Color(0.969, 0.918, 0.408, 1.0)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.blood -= damage
		Global.player.play_damage_flash()
		Global.player.velocity += direction * knockback_force
	
	var sprite: DissapearSprite = DissapearSprite.new()
	get_parent().add_child(sprite)
	sprite.global_position = global_position
	sprite.texture = TextureHelper.create_circle_texture_gradient(randi_range(4, 6), INNER_SHOT_BLOOD_COLOR, OUTER_SHOT_BLOOD_COLOR)
	
	sprite.disapear_after(5.0, true)
	
	queue_free()
