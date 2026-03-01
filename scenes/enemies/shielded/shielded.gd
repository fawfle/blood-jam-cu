extends Enemy

@onready var animated_sprite = $AnimatedSprite2D

# shield guy works similarly to shooter, but min distance will change
@export var distance_min: int
var distance_target_min = 80
var distance_target_max = 200

var distance_target

var distIndex = 0;

const DISTANCE_TOLERANCE: float = 0.1

func _on_ready():
	change_distance()
	
func choose_animation() -> void:
	if velocity == Vector2.ZERO:
		animated_sprite.play("idle")
	elif velocity.x > 0 && velocity.x > velocity.y:
		animated_sprite.flip_h = true
		animated_sprite.play("run_side")
	elif velocity.x < 0 && velocity.x > velocity.y:
		animated_sprite.flip_h = false
		animated_sprite.play("run_side")
	elif velocity.y > 0 && velocity.y > velocity.x:
		animated_sprite.play("run_down")
	elif velocity.y < 0 && velocity.y > velocity.x:
		animated_sprite.play("run_up")

func find_direction() -> void:
	var enemy_position: Vector2 = global_position
	var player_position: Vector2 = player.global_position
	var distance: float = enemy_position.distance_to(player_position)
	# if player too close, go away from player otherwise go towards 
	if abs(distance - distance_target) < DISTANCE_TOLERANCE:
		direction = Vector2.ZERO
	if distance < distance_target:
		direction = -enemy_position.direction_to(player_position)
	elif distance > distance_target:
		direction = enemy_position.direction_to(player_position)
	else:
		direction = Vector2.ZERO

func change_distance():
	distance_target = randf_range(distance_target_min, distance_target_max)

func _on_timer_timeout() -> void:
	change_distance()
