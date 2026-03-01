extends Node2D

var main_game: PackedScene = preload("res://scenes/main.tscn")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_game)
