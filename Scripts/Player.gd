extends RigidBody2D

onready var _collision = get_node("CollisionShape2D")
onready var _stopping_tip : Sprite = get_node("StoppingTip")

var _start_motion_pos : Vector2
var _end_motion_Pos : Vector2
var _direction : Vector2
var _distance
var _max_distance = 400

var _stopping : bool
var _dragging : bool

export var power : int = 5

func _physics_process(delta):
	if linear_velocity.length() < 30:
		_stopping = true
	else:
		_stopping = false
	
	_stopping_tip.visible = _stopping
	
func _input(event):
	if event is InputEventMouseButton:
		var pos = get_global_mouse_position()
		
		if event.pressed && _stopping:
			_start_motion_pos = pos
			sleeping = true
			_dragging = true
		elif !event.pressed && _dragging:
			sleeping = false
			_dragging = false
			var force = _distance * power
			apply_central_impulse(_direction * force)
			update()
			
	if event is InputEventMouseMotion && _dragging:
		_end_motion_Pos = get_global_mouse_position()
		_direction = _end_motion_Pos.direction_to(_start_motion_pos)
		_distance = min(_end_motion_Pos.distance_to(_start_motion_pos), _max_distance)
		update()
	
func _integrate_forces(state):
	rotation_degrees = 0
	
func _draw():
	if _dragging:
		draw_circle(_start_motion_pos - position, 15, Color.white)
		draw_line(_start_motion_pos - position, _end_motion_Pos - position, Color.white, 5)
		
		draw_line(Vector2.ZERO, Vector2(1, 1) * _distance * _direction, Color.dodgerblue, 3)
