extends PhysicsBody3D # This works for both RigidBody and StaticBody

@export var is_door_open : bool = false

func pointer_event(event: XRToolsPointerEvent):
	# event.pointer is the FunctionPointer node
	# Usually, the parent of the FunctionPointer is the XRController3D
	var controller : XRController3D = event.pointer.get_parent()
	
	# 2. To check for a SPECIFIC button (e.g., Grip or AX) 
	# even if it's not the pointer's main action:
	if controller and controller.is_button_pressed("trigger_click"):
		if $AnimationPlayer.is_playing():
			return
		run_door()

func run_door():
	if is_door_open:
		$AnimationPlayer.play("door_close")
		$open.play()
	else:
		$AnimationPlayer.play("door_open")
		$close.play()
	is_door_open = !is_door_open
