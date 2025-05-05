extends CharacterBody3D

@export var base_speed := 5

@onready var camera = $CameraController/Camera3D

var movement_input := Vector2.ZERO

func _physics_process(_delta: float) -> void:
	movement_input = Input.get_vector("left", "right", "forward", "backward").rotated(-camera.global_rotation.y)
	velocity = Vector3(movement_input.x, 0, movement_input.y) * base_speed
	move_and_slide()
