extends RigidBody2D

onready var _collision = get_node("CollisionShape2D")
var _radius = 0

var _end_motion_Pos : Vector2

func _ready():
	_radius = _collision.shape.radius
	
func _input(event):
	if event is InputEventMouseButton:
		var pos = get_global_mouse_position()
		if event.pressed && linear_velocity.length() < 30 && _check_is_tapped(pos):
			sleeping = true
		elif !event.pressed && sleeping:
			sleeping = false
			var direction = _end_motion_Pos.direction_to(position)
			var distance = _end_motion_Pos.distance_to(position)
			var force = min(distance, 250) * 5
			apply_central_impulse(direction * force)
			update()
			
	if event is InputEventMouseMotion && sleeping:
		_end_motion_Pos = get_global_mouse_position()
		update()
	
func _check_is_tapped(tapped_position):
	return position.distance_to(tapped_position) < _radius
	
func _integrate_forces(state):
	rotation_degrees = 0
	
func _draw():
	if sleeping:
		draw_line(Vector2.ZERO, _end_motion_Pos - position, Color.red, 2)
