class_name Shield extends Node2D

@onready var shield: StaticBody2D = $Shield

@onready var shield_collision: CollisionShape2D = $Shield/CollisionShape2D
@onready var shield_sprite: Sprite2D = $Sprite2D

## rotation speed in radians
var rotation_speed: float = 0.5

func _process(delta: float) -> void:
	var angle_to_player: float = get_angle_to(Global.player.global_position)
	
	var rotate_angle: float = max(abs(angle_to_player), rotation_speed) * sign(angle_to_player)
	
	rotate(rotate_angle * delta)

func set_enabled(enabled: bool):
	shield.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT if enabled else Node.PROCESS_MODE_DISABLED)

func set_shield_size(s: Vector2):
	(shield_collision.shape as CapsuleShape2D).radius = s.x
	(shield_collision.shape as CapsuleShape2D).height = s.y
	(shield_sprite.texture as GradientTexture2D).width = s.x
	(shield_sprite.texture as GradientTexture2D).height = s.y
