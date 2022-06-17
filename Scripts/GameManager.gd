extends Node2D

export(Array, PackedScene) var _level_secnes

onready var _timerLabel = get_node("CanvasLayer/TimerLabel")
onready var _result = get_node("CanvasLayer/Result")
onready var _player = get_node("Player")
onready var _camera = get_node("Camera2D")
onready var _tween = get_node("Tween")

var _current_level_scene_index = 0
var _next_level_height = 0
var _pre_level_height = 1280

var _next_level_scene
var _current_level_scene
var _pre_level_scene

func _ready():
	_current_level_scene = get_node("Level1")
	_create_next_level_scene(_current_level_scene_index + 1)
	_timerLabel.start()
	
func _physics(delta):
	if _player.position.y < _next_level_height:
		_move_to_next_level()
	elif _player.position.y > _pre_level_height:
		_move_to_pre_level()

func _move_to_next_level():
	_current_level_scene_index += 1
	_pre_level_height = _next_level_height
	_next_level_height = _next_level_height - 1280
	_tween.interpolate_property(_camera, "position", _camera.position, Vector2(0, _next_level_height), 0.5)
	_tween.start()
	
	if _pre_level_scene != null:
		_pre_level_scene.queue_free()
		
	_pre_level_scene = _current_level_scene
	_current_level_scene = _next_level_scene
	_create_next_level_scene(_current_level_scene_index + 1)
	
func _move_to_pre_level():
	_current_level_scene_index -= 1
	_next_level_height = _pre_level_height
	_tween.interpolate_property(_camera, "position", _camera.position, Vector2(0, _pre_level_height), 0.5)
	_pre_level_height = _next_level_height + 1280
	_tween.start()
	
	if _next_level_scene != null:
		_next_level_scene.queue_free()
		
	_next_level_scene = _current_level_scene
	_current_level_scene = _pre_level_scene
	_create_pre_level_scene(_current_level_scene_index - 1)

func _create_next_level_scene(index):
	if index >= _level_secnes.size():
		_next_level_scene = null
		return
	
	_next_level_scene = _level_secnes[index].instance()
	_next_level_scene.position = Vector2(0, _next_level_height - 1280)
	add_child(_next_level_scene)
	
func _create_pre_level_scene(index):
	if index < 0:
		_pre_level_scene = null
		return
		
	_pre_level_scene = _level_secnes[index].instance()
	_pre_level_scene.position = Vector2(0, _pre_level_height)
	add_child(_pre_level_scene)
	
func set_game_over():
	_timerLabel.stop()
	_result.visible = true
	_result.set_time(_timerLabel.text)
