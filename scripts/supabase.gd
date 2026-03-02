class_name Supabase extends Node

const PROJECT_ID: String = "hxbqzficybsjtyuyjlum"
const SUPABASE_URL: String = "https://hxbqzficybsjtyuyjlum.supabase.co"
const SUPABASE_REST: String = SUPABASE_URL + "/rest/v1/"
const SUPABASE_KEY: String = "sb_publishable_ta_-KIjwkmsg0n4ozWvHUw_rDuRtsjf"
const LEADERBOARD_REQUEST: String = SUPABASE_URL + SUPABASE_REST + "leaderboard?apikey=" + SUPABASE_KEY
# const LEADERBOARD_URL: String = "https://hxbqzficybsjtyuyjlum.supabase.co/rest/v1/leaderboard?apikey=sb_publishable_ta_-KIjwkmsg0n4ozWvHUw_rDuRtsjf"

signal leaderboard_fetched(leaderboard_data: Array)
signal score_submitted()

func get_leaderboard():
	print("Supabase: Getting Leaderboard")
	_fetch_leaderboard_async()

func _fetch_leaderboard_async() -> void:
	var http_request: HTTPRequest = HTTPRequest.new()
	http_request.request_completed.connect(_handle_leaderboard_request)
	http_request.request(LEADERBOARD_REQUEST)

func _handle_leaderboard_request(result, response_code, headers, body):
	print(result)
