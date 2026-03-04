extends Node2D

func _on_button_pressed() -> void:
	SceneManager.load_scene(SceneManager.game_scene)



func _on_leaderboard_button_pressed() -> void:
	Leaderboard.show_window()
