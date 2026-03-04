extends Node

var input_command: String = "":
	get: return input_command
	set(value): input_command = value #.to_lower()
var input_num: String = ""

var debug_mode: bool = false

func _ready() -> void:
	if OS.has_feature("editor"):
		debug_mode = true

func _input(event: InputEvent) -> void:
	if event is not InputEventKey: return;
	event = event as InputEventKey;
	
	if event.pressed and event.keycode == KEY_ENTER:
		handle_command(input_command)
		input_command = ""
	elif event.pressed:
		if event.keycode == KEY_BACKSPACE: input_command = input_command.substr(0, len(input_command) - 1)
		elif event.unicode != 0: input_command +=  char(event.unicode);
	
	if not debug_mode: return

	elif event.pressed and event.keycode >= KEY_0 and event.keycode <= KEY_9:
		input_num += event.as_text_keycode();
	elif event.pressed and event.keycode == KEY_ENTER:
		input_num = "";

func handle_command(command: String):
	print("Entered Command: " + command);
	if command == "enterdebug":
		print("ENTERING DEBUG MODE")
		debug_mode = true
		return;
	
	if not debug_mode or len(input_command) <= 0: return
	
	if input_command.begins_with("b"):
		Global.blood += int(input_num)
	elif input_command.begins_with("br"):
		Global.blood = int(input_num)
	elif input_command.begins_with("r"):
		Global.main.resize_room()
	#elif input_command.begins_with("s"):
	#	Global.main.enemy_spawn_time = 0.2
	elif input_command.begins_with("k"):
		Global.out_of_blood.emit()
	elif input_command.begins_with("s"):
		match(input_command.substr(1)):
			"f": Global.main.enemy_spawn_rates[Main.EnemyType.FODDER] = 10000
			"s": Global.main.enemy_spawn_rates[Main.EnemyType.SHOOTER] = 10000
			"sh": Global.main.enemy_spawn_rates[Main.EnemyType.SHIELDED] = 10000
			"j": Global.main.enemy_spawn_rates[Main.EnemyType.JANITOR] = 10000
			"fl": Global.main.enemy_spawn_rates[Main.EnemyType.FLAMER] = 10000
			"d": Global.main.enemy_spawn_rates[Main.EnemyType.DUCK] = 10000
	elif input_command.begins_with("deletesave"):
		Save.delete_save()
	elif input_command.begins_with("g"):
		Global.player.collision_shape.disabled = true
		Global.player.bleed_per_second = 0
		Global.player.bleed_per_second_small = 0
		Global.player.dash_cost = 0
