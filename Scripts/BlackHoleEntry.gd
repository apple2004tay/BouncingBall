extends Area2D

export(NodePath) var _black_hole_exit_path

var _player
var _black_hole_exit

onready var _tween : Tween = get_node("Tween")

func _ready():
	_black_hole_exit = get_node(_black_hole_exit_path)
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	_player = body
	_player.change_mode_kinematic()
	_player.enableControl = false

	_tween.interpolate_property(_player, "scale", Vector2.ONE, Vector2.ZERO, 0.5)
	_tween.interpolate_property(_player, "position", _player.position, global_position, 0.2)
	_tween.connect("tween_all_completed", self, "_on_entry_anim_completed")
	_tween.start()
	
func _on_entry_anim_completed():
	_tween.disconnect("tween_all_completed", self, "_on_entry_anim_completed")
	
	_player.teleport_pos = _black_hole_exit.global_position
	_player.teleporting = true
	
	_tween.interpolate_property(_player, "scale", Vector2.ZERO, Vector2.ONE, 0.5)
	_tween.connect("tween_all_completed", self, "_on_exit_anim_completed")
	_tween.start()
	
func _on_exit_anim_completed():
	_tween.disconnect("tween_all_completed", self, "_on_exit_anim_completed")
	_player.change_mode_rigid()
	_player.teleporting = false
	yield(get_tree().create_timer(0.5),"timeout")
	_player.enableControl = true
