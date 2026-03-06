extends CanvasLayer

var current_data: Array = []

@onready var close_button: TextureButton = $Panel/Close
@onready var leaderboard_container: VBoxContainer = $Panel/ScrollContainer/VBoxContainer

@onready var change_name_edit: LineEdit = $ChangeNameEdit

var leaderboard_entry_scene: PackedScene = preload("res://scenes/ui/leaderboard/leaderboard_entry.tscn")

const MAX_USERNAME_LENGTH: int = 15

func _ready() -> void:
	visible = false
	Supabase.leaderboard_fetched.connect(update_with_leaderboard_data)
	
	change_name_edit.placeholder_text = Save.player_name
	
	# update_with_leaderboard_data(Supabase.current_leaderboard)
	visibility_changed.connect(_on_visibility_changed)
	
	close_button.pressed.connect(hide_window)
	change_name_edit.text_submitted.connect(update_name)
	
	SceneManager.scene_changed.connect(hide_window)
	
	Global.menu_changed.connect(_on_menu_changed)

func _on_visibility_changed():
	if visible:
		Supabase.get_leaderboard()

func update_with_leaderboard_data(leaderboard_data: Array):
	clear_leaderboard()
	# print(leaderboard_data)
	for i in range(len(leaderboard_data)):
		var data = leaderboard_data[i]
		var entry: LeaderboardEntry = add_leaderboard_entry(i, data)
		if data.id == Save.uuid:
			entry.highlight()

func clear_leaderboard():
	for child in leaderboard_container.get_children():
		child.queue_free()

func add_leaderboard_entry(index: int, data) -> LeaderboardEntry:
	var leaderboard_entry: LeaderboardEntry = leaderboard_entry_scene.instantiate()
	leaderboard_container.add_child(leaderboard_entry)
	leaderboard_entry.load_data(index, data)
	return leaderboard_entry

func _on_menu_changed(node: Node, visibility: bool):
	if node == self: return
	if visibility: hide_window()

func hide_window():
	visible = false
	Global.menu_changed.emit(self, visible)

func show_window():
	visible = true
	Global.menu_changed.emit(self, visible)

func toggle_window():
	visible = not visible
	Global.menu_changed.emit(self, visible)

func update_name(new_name: String):
	Save.player_name = new_name
	Save.save_data()
	change_name_edit.placeholder_text = new_name
	change_name_edit.clear()
	
	if Save.high_score != 0:
		Supabase.submit_score(Save.uuid, Save.high_score, Save.player_name)
		
		await Supabase.score_submitted
		
		Supabase.get_leaderboard()
