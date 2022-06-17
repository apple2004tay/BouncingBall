extends Area2D

func _ready():
	connect("body_entered", self, "_on_player_entered")
	
func _on_player_entered(body):
	body.queue_free()
	var gm = get_tree().root.get_node("GameManager")
	gm.set_game_over()
	

