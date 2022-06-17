extends RigidBody2D

onready var _collision = get_node("CollisionShape2D")
var _radius = 0

var _start_motion_pos : Vector2
var _end_motion_Pos : Vector2
var direction : Vector2
var distance

func _ready():
	_radius = _collision.shape.radius
	
func _input(event):
	if event is InputEventMouseButton:
		var pos = get_global_mouse_position()
		if event.pressed && linear_velocity.length() < 30:
			_start_motion_pos = pos
			sleeping = true
		elif !event.pressed && sleeping:
			sleeping = false
			var force = distance * 5
			apply_central_impulse(direction * force)
			update()
			
	if event is InputEventMouseMotion && sleeping:
		_end_motion_Pos = get_global_mouse_position()
		direction = _end_motion_Pos.direction_to(_start_motion_pos)
		distance = min(_end_motion_Pos.distance_to(_start_motion_pos), 300)
		update()
	
func _integrate_forces(state):
	rotation_degrees = 0
	
func _draw():
	if sleeping:
		#draw_circle(_start_motion_pos - position, 15, Color.red)
		#draw_line(_start_motion_pos - position, _end_motion_Pos - position, Color.red, 2)
		draw_line(Vector2.ZERO, Vector2(1, 1) * distance * direction, Color.red, 5)
