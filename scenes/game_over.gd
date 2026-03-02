extends CanvasLayer

@onready var score_label = $GameOverMenu/RichTextLabel

func _ready() -> void:
	score_label.text = "Score\n" + str(Global.score)

func _on_play_again_pressed() -> void:
	SceneManager.load_scene(SceneManager.game_scene)


func _on_exit_game_pressed() -> void:
	SceneManager.load_scene(SceneManager.main_menu)
