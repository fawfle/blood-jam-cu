extends Node

var uuid: String
var high_score: int = 0
var player_name: String = "username"

func _ready() -> void:
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	
	if save_file == null:
		create_new_save()
		save_data()
		return
		
	print("Loading previous save")
	var json_string = save_file.get_line()
	var data = JSON.parse_string(json_string)
	uuid = data.uuid
	high_score = data.high_score
	player_name = data.player_name

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
		"player_name": player_name
	}
	var json_string = JSON.stringify(data)
	save_file.store_line(json_string)

func create_new_save():
	uuid = UUID.uuid4()
	print(uuid)

func delete_save():
	DirAccess.remove_absolute("user://savegame.save")
	
