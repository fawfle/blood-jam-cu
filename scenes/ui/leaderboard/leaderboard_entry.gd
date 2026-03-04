class_name LeaderboardEntry extends Control

@onready var place_label: Label = $Place
@onready var name_label: Label = $Name
@onready var score_label: Label = $Score

@export var highlighted_color = Color(0.828, 0.828, 0.0, 1.0)

func load_data(index: int, data):
	place_label.text = str(index + 1) + "."
	name_label.text = (data.user_name as String).substr(0, Leaderboard.MAX_USERNAME_LENGTH)
	score_label.text = str(int(data.score))

func highlight():
	place_label.modulate = highlighted_color
	name_label.modulate = highlighted_color
	score_label.modulate = highlighted_color
