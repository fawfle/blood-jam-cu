extends Node2D

func _on_button_pressed() -> void:
	SceneManager.load_scene(SceneManager.game_scene)

func _on_leaderboard_button_pressed() -> void:
	Leaderboard.toggle_window()

func _on_options_button_pressed() -> void:
	OptionsMenu.toggle_window()
