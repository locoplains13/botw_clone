extends Node3D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_from_vector(event.relative * 0.005)
		print(event.relative)

func rotate_from_vector(v: Vector2):
	if v.length() == 0: return
	
	## changing to -= makes camera controls inverted
	
	rotation.y += v.x 
	rotation.x += v.y
	rotation.x = clamp(rotation.x, -0.5,0.5)
	
	print(rotation.x)
