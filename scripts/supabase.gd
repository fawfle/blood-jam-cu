extends Node

const PROJECT_ID: String = "hxbqzficybsjtyuyjlum"
const SUPABASE_URL: String = "https://hxbqzficybsjtyuyjlum.supabase.co"
const SUPABASE_REST: String = "/rest/v1/"
const SUPABASE_KEY: String = "sb_publishable_ta_-KIjwkmsg0n4ozWvHUw_rDuRtsjf"
const LEADERBOARD_REQUEST: String = SUPABASE_URL + SUPABASE_REST + "leaderboard?apikey=" + SUPABASE_KEY 
# const LEADERBOARD_URL: String = "https://hxbqzficybsjtyuyjlum.supabase.co/rest/v1/leaderboard?apikey=sb_publishable_ta_-KIjwkmsg0n4ozWvHUw_rDuRtsjf"

signal leaderboard_fetched(leaderboard_data: Array)
signal score_submitted()

var current_leaderboard: Array

func _ready() -> void:
	get_leaderboard()

func get_leaderboard():
	print("Supabase: Getting Leaderboard")
	_fetch_leaderboard_async()

func _fetch_leaderboard_async() -> void:
	var http_request: HTTPRequest = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_handle_leaderboard_request)
	http_request.request(LEADERBOARD_REQUEST + "&order=score.desc")

func _handle_leaderboard_request(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray):
	if response_code != 200:
		push_error("Failed to get leaderboard. Response code: " + str(response_code) + "\n" + body.get_string_from_utf8())
		return
	
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
	current_leaderboard = json

func submit_score(player_uuid: String, score: int, player_name: String) -> void:
	print("Submitting score: %f for player: %s" % [score, player_uuid])
	
	var body: Dictionary = {
		"id": player_uuid,
		"score": score,
		"user_name": player_name,
		"last_submit": get_postgres_timestamp_utc()
	}
	
	print(body)
	
	var json_body = JSON.stringify(body)
	_submit_score_async(json_body)

func _submit_score_async(json_body: String) -> void:
	var http_request: HTTPRequest = HTTPRequest.new()
	add_child(http_request)
	
	http_request.request_completed.connect(_handle_submit_score_request)
	
	var headers = [
		"Content-Type: application/json",
		"Accept: application/json",
        "Prefer: resolution=merge-duplicates"
	]
	
	http_request.request(LEADERBOARD_REQUEST, headers, HTTPClient.METHOD_POST, json_body)

func _handle_submit_score_request(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if not response_code in [200, 201]:
		push_error("Failed to submit score. Response code: " + str(response_code) + "\n" + body.get_string_from_utf8())
		return
	
	print("Successfully submitted score.")

static func get_postgres_timestamp_utc() -> String:
	return Time.get_datetime_string_from_system(true, false) + "Z"
