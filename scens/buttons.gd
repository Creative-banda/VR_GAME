extends StaticBody3D

# Define the signal. We will pass the button's type (String or Int)
signal printer_button_pressed(button_type)

@export_enum("left", "right", "up", "down", "center") var my_type: String = "center"

func pointer_event(event: XRToolsPointerEvent):
	
	var controller : XRController3D = event.pointer.get_parent()
	if controller and controller.is_button_pressed("trigger_click"):
		printer_button_pressed.emit(my_type)
		
