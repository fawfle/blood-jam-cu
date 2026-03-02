extends CanvasLayer


func _on_play_again_pressed() -> void:
	SceneManager.load_scene(SceneManager.game_scene)


func _on_exit_game_pressed() -> void:
	SceneManager.load_scene(SceneManager.main_menu)
