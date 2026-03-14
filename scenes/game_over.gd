extends CanvasLayer

@onready var score_label = $GameOverMenu/RichTextLabel

func _ready() -> void:
	score_label.text = "Score\n" + str(Global.score)
	var updated: bool = Save.save_high_score(Global.score)
	if updated: Supabase.submit_score(Save.uuid, Global.score, Save.player_name)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		SceneManager.load_scene(SceneManager.game_scene)

func _on_play_again_pressed() -> void:
	SceneManager.load_scene(SceneManager.game_scene)


func _on_exit_game_pressed() -> void:
	SceneManager.load_scene(SceneManager.main_menu)
