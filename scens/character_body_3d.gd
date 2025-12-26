extends CharacterBody3D

const JOY_AXIS_0 = 0
const JOY_AXIS_1 = 1

@export var speed = 3.0
var input_dir = Vector2.ZERO

@onready var xr_origin = get_node("XROrigin3D") # Adjust path as necessary
@onready var vr_camera = xr_origin.get_node("Camera3D")  # Adjust camera node name/path

func _process(delta):
	input_dir.x = Input.get_joy_axis(0, JOY_AXIS_0)
	input_dir.y = -Input.get_joy_axis(0, JOY_AXIS_1)

func _physics_process(delta):
	var forward = -vr_camera.global_transform.basis.z
	var right = vr_camera.global_transform.basis.x

	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()

	var direction = forward * input_dir.y + right * input_dir.x
	if direction.length() > 0.1:
		velocity = direction * speed
	else:
		velocity = Vector3.ZERO

	move_and_slide()
