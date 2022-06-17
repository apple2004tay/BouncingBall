extends Panel

onready var _time_label:Label = get_node("ResultTimeLabel")
onready var _restart_button:Button = get_node("RestartButton")

func _ready():
	_restart_button.connect("button_down", self, "_restart_game")
	
func set_time(time_text):
	_time_label.text = time_text
	
func _restart_game():
	get_tree().change_scene("res://Scenes/BouncingBallGame.tscn")
