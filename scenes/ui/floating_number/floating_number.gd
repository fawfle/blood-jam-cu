class_name FloatingNumber extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
# @onready var label = $Label

func _ready() -> void:
	animation_player.play("float")
	await animation_player.animation_finished
	queue_free()

func set_text(text: String):
	$Label.text = text
