extends CharacterBody3D

@export var base_speed := 5
@export var run_speed := 8

@onready var camera = $CameraController/Camera3D
@onready var skin = $GodetteSkin
#jump
@export var jump_height : float = 2.25
@export var jump_time_to_peak : float = 0.4
@export var jump_time_to_descent : float = 0.3

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var movement_input := Vector2.ZERO

func _physics_process(delta: float) -> void:
	move_logic(delta)
	jump_logic(delta)
	ability_logic()
	move_and_slide()

func move_logic(delta) -> void:
	movement_input = Input.get_vector("left", "right", "forward", "backward").rotated(-camera.global_rotation.y)
	var vel_2d = Vector2(velocity.x, velocity.z)
	
	var is_running := Input.is_action_pressed("run") ## to check if the player is pressing the run button
	
	#if input is detected, then move the player
	if movement_input != Vector2.ZERO: 
		var speed = run_speed if is_running else base_speed ## make default speed equal to run_speed if var is true, otherwise, keep base_speed
		vel_2d += movement_input * speed * delta
		vel_2d = vel_2d.limit_length(speed)
		velocity.x = vel_2d.x
		velocity.z = vel_2d.y
		skin.set_move_state("Running_B")
		var target_angle = -movement_input.angle() + PI/2
		skin.rotation.y = rotate_toward(skin.rotation.y, target_angle, 7 * delta)
	else: 
		## if the player isn't moving
		vel_2d = vel_2d.move_toward(Vector2.ZERO, base_speed * 4.0 * delta)
		velocity.x = vel_2d.x
		velocity.z = vel_2d.y
		skin.set_move_state("Idle")

func jump_logic(delta: float) -> void:
	## if player is on the floor and presses jump, make player move up
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_velocity
	else:
		skin.set_move_state("Jump_Idle")
		var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity #player will fall with gravity if they reach the peak
		velocity.y -= gravity * delta

func ability_logic() -> void:
	if Input.is_action_just_pressed("ability"):
		skin.attack()
