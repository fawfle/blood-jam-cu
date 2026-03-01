extends Control

@onready var player_indicator = $PlayerIndicator

func _process(_delta: float) -> void:
	player_indicator.position = Global.player.global_position / 8 / Global.room_size_ratio
