extends Node

var save_data = {
	"score": 0,
	"name": "NAME",
	"stages_cleared" : 0,
	"game_beat" : 0
}

func save_score(content):
	var file = FileAccess.open("user://high_scores.dat", FileAccess.WRITE)
	var json_string = JSON.stringify(content)
	file.store_line(json_string)
	file.close()

func load_high_scores():
	if not FileAccess.file_exists("user://high_scores.dat"):
		return
	var file = FileAccess.open("user://high_scores.dat", FileAccess.READ)
	while file.get_position() < file.get_length():
		var json_string = file.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		# Get the data from the JSON object
		var score_date = json.get_data()
		
#
func save_progress():
	pass

