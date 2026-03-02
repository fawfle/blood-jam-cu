extends Enemy

@export var clean_radius: int = 20
@export var clean_distance :float = 20
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(_delta: float) -> void:
	clean_blood()
	find_direction()

func choose_animation() -> void:
	if velocity == Vector2.ZERO:
		animated_sprite.play("idle")
	elif velocity.x > 0 && velocity.x > velocity.y:
		animated_sprite.flip_h = true
		if animated_sprite.animation != "movement":
			animated_sprite.play("movement")
	elif velocity.x < 0 && velocity.x > velocity.y:
		animated_sprite.flip_h = false
		if animated_sprite.animation != "movement":
			animated_sprite.play("movement")

func find_direction() -> void:
	var enemy_position: Vector2 = position
	var player_position: Vector2 = player.position
	direction = enemy_position.direction_to(player_position)

func clean_blood() -> void:
	if Global.ground == null: return
	var clean_position = global_position + (Vector2.RIGHT if animated_sprite.flip_h == true else Vector2.LEFT) * clean_distance
	var painted: int = Global.ground.clear_circle(clean_position, clean_radius)
	velocity = velocity.move_toward(Vector2.ZERO, painted)
