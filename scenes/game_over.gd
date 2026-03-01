extends Control

var main_menu: PackedScene = preload("res://scenes/main_menu.tscn")
var game_scene: PackedScene = preload("res://scenes/main.tscn")

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)

func _on_exit_game_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)
