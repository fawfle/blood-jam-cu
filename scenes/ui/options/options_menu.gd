extends CanvasLayer

@onready var music_volume_slider: HSlider = $MusicVolumeSlider

func _ready() -> void:
	visible = false
	music_volume_slider.value_changed.connect(_on_music_volume_value_changed)
	
	Global.menu_changed.connect(_on_menu_changed)
	
	music_volume_slider.value = Save.music_volume

func show_window():
	visible = true
	Global.menu_changed.emit(self, visible)

func hide_window():
	visible = false
	Global.menu_changed.emit(self, visible)

func toggle_window():
	visible = not visible
	Global.menu_changed.emit(self, visible)

func _on_music_volume_value_changed(value: float):
	Save.music_volume = value
	Save.save_data()


func _on_menu_changed(node: Node, visibility: bool):
	if node == self: return
	if visibility: hide_window()
