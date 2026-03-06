extends Node

var uuid: String
var high_score: int = 0
var player_name: String
## volume of music. 1 is max
var music_volume: float = 1

# call before everything else!
func _init() -> void:
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	
	if save_file == null:
		create_new_save()
		save_data()
		return
		
	print("Loading previous save")
	var json_string = save_file.get_line()
	var data: Dictionary = JSON.parse_string(json_string)
	uuid = data.uuid
	high_score = data.high_score
	player_name = data.player_name
	if data.has("music_volume"): music_volume = data.music_volume
	
	# apply volume
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), music_volume)

func save_high_score(new_high_score: int) -> bool:
	if high_score >= new_high_score: return false
	high_score = new_high_score
	save_data()
	return true

func save_data():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var data = {
		"uuid": uuid,
		"high_score": high_score,
		"player_name": player_name,
		"music_volume": music_volume
	}
	var json_string = JSON.stringify(data)
	save_file.store_line(json_string)

func create_new_save():
	uuid = UUID.uuid4()
	player_name = "player"
	print(uuid)

func delete_save():
	DirAccess.remove_absolute("user://savegame.save")
