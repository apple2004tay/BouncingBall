extends Node2D

export(Array, PackedScene) var _level_secnes

onready var _player = get_node("Player")
onready var _camera = get_node("Camera2D")
onready var _tween = get_node("Tween")

var _current_level_scene_index = 0
var _next_level_height = 0
var _pre_level_height = 1280

func _ready():
	_create_next_level_scene(_current_level_scene_index + 1)

func _physics_process(delta):
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
	
func _move_to_pre_level():
	_current_level_scene_index -= 1
	_next_level_height = _pre_level_height
	_tween.interpolate_property(_camera, "position", _camera.position, Vector2(0, _pre_level_height), 0.5)
	_pre_level_height = _next_level_height + 1280
	_tween.start()

func _create_next_level_scene(index):
	if index >= _level_secnes.size():
		return
	
	var level_scene = _level_secnes[index].instance()
	level_scene.position = Vector2(0, _next_level_height - 1280)
	add_child(level_scene)
	
func _create_pre_level_scene(index):
	if index < 0:
		return
		
	var level_scene = _level_secnes[index].instance()
	level_scene.position = Vector2(0, _pre_level_height)
	add_child(level_scene)
