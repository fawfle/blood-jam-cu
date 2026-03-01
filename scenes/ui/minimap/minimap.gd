extends Control

@onready var player_indicator = $PlayerIndicator
@export var enemy_indicator: PackedScene
var enemy_indicators = {}

func _process(_delta: float) -> void:
	player_indicator.position = Global.player.global_position / 8 / Global.room_size_ratio
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if !enemy_indicators.has(enemy):
			var indicator = enemy_indicator.instantiate()
			add_child(indicator)
			enemy_indicators[enemy] = indicator
		enemy_indicators[enemy].position = enemy.global_position / 8 / Global.room_size_ratio
	for enemy in enemy_indicators.keys():
		if !is_instance_valid(enemy):
			enemy_indicators[enemy].queue_free()
			enemy_indicators.erase(enemy)
	
