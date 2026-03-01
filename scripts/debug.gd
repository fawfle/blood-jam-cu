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
	if input_command.begins_with("br"):
		Global.blood = int(input_num)
	if input_command.begins_with("r"):
		Global.main.resize_room()
	if input_command.begins_with("s"):
		Global.main.enemy_spawn_time = 0.2
