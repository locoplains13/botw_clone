extends Node3D

@export var min_limit_x: float
@export var max_limit_x: float
@export var mouse_acceleration := 0.005

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_from_vector(event.relative * mouse_acceleration)

func rotate_from_vector(v: Vector2):
	if v.length() == 0: return
	
	## changing to -= makes camera controls inverted
	
	rotation.y += v.x 
	rotation.x += v.y
	rotation.x = clamp(rotation.x, min_limit_x, max_limit_x)
