extends Node2D

@export var target: Node2D

func _process(delta: float) -> void:
	if target == null: return
	
	global_position = floor(target.global_position)
