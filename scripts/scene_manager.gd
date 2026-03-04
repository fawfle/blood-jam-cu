extends Node

var main_menu: PackedScene = preload("res://scenes/main_menu.tscn")
var game_scene: PackedScene = preload("res://scenes/main.tscn")

var transitioning: bool = false

var blood_wipe_scene: PackedScene = preload("res://scenes/ui/blood_wipe/blood_wipe.tscn")
var blood_wipe: CanvasLayer

var transition_duration: float  = 0.5

## offset to complete wipe in/start wipe out
var wipe_in_start: float = -300
var wipe_in_target: float = -85
## offset to complete wipe out
var wipe_out_target: float = -85 + 300

signal scene_changed()

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
	
	await get_tree().create_timer(0.25).timeout
	
	if scene == game_scene:
		Global.reset_game()
	
	get_tree().change_scene_to_packed(scene)
	scene_changed.emit()
	
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
