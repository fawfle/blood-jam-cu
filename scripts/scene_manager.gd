extends Node

var main_menu: PackedScene = preload("res://scenes/main_menu.tscn")
var game_scene: PackedScene = preload("res://scenes/main.tscn")

var transitioning: bool = false

var blood_wipe_scene: PackedScene = preload("res://scenes/ui/blood_wipe/blood_wipe.tscn")
var blood_wipe: CanvasLayer

var transition_duration: float  = 1

## offset to complete wipe in/start wipe out
var wipe_in_start: float = -400
var wipe_in_target: float = 400
## offset to complete wipe out
var wipe_out_target: float = 800

func _ready() -> void:
	blood_wipe = blood_wipe_scene.instantiate()
	add_child(blood_wipe)
	blood_wipe.visible = false

func load_scene(scene: PackedScene):
	if transitioning:
		push_warning("Trying to transition when already transitioning")
		return
	
	transitioning = true
	await wipe_in()
	get_tree().change_scene_to_packed(scene)
	await wipe_out()
	
	transitioning = false

func wipe_in():
	blood_wipe.visible = true
	var tween: Tween = create_tween()
	tween.tween_property(blood_wipe, "offset", Vector2(0, wipe_in_target), transition_duration).from(Vector2(0, wipe_in_start))
	
	await tween.finished

func wipe_out():
	var tween: Tween = create_tween()
	tween.tween_property(blood_wipe, "offset", Vector2(0, wipe_out_target), transition_duration).from(Vector2(0, wipe_in_target))
	
	await tween.finished
	
	blood_wipe.visible = false
