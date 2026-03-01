class_name Shield extends Node2D

@onready var shield: StaticBody2D = $Shield

## rotation speed in radians
var rotation_speed: float = 0.5

func _process(delta: float) -> void:
	var angle_to_player: float = get_angle_to(Global.player.global_position)
	
	var rotate_angle: float = max(abs(angle_to_player), rotation_speed) * sign(angle_to_player)
	
	rotate(rotate_angle * delta)

func set_enabled(enabled: bool):
	shield.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT if enabled else Node.PROCESS_MODE_DISABLED)
