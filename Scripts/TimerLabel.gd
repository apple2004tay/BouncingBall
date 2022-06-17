extends Label

var _start = false
var _time = 0
var _h = 0
var _m = 0
var _s = 0

func start():
	_start = true
	
func stop():
	_start = false

func _process(delta):
	if _start:
		_time += delta
		_h = int(_time) / 3600
		_m = int(_time) % 3600 / 60
		_s = int(_time) % 60
		text = "{0}:{1}:{2}".format({"0": "%0*d" % [2, _h], "1": "%0*d" % [2, _m], "2": "%0*d" % [2, _s]})
