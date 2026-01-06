extends Node3D

@onready var plane_node = $PrintingPlane
@onready var model_1: MeshInstance3D = $model_1
@onready var model_2: MeshInstance3D = $model_2
@onready var model_3: MeshInstance3D = $model_3
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var status_label: Label3D = $status_label

# 1. Models Array
@onready var models = [model_1, model_2, model_3]

# 2. Colors Setup
var colors = [Color.RED, Color.BLUE, Color.BLACK]
var color_index: int = 0

var current_index: int = 0 # 0 = model_1, 1 = model_2, 2 = model_3
var current_model: MeshInstance3D
var can_press: bool = true

func _ready() -> void:
	# Initialize the first model and default color
	update_model_selection()

func _process(_delta):
	if current_model:
		var current_height = plane_node.global_position.y
		var mat = current_model.get_active_material(0) as ShaderMaterial
		if mat:
			mat.set_shader_parameter("cutoff_y", current_height)

func update_model_selection():
	current_model = models[current_index]
	
	for i in range(models.size()):
		models[i].visible = (i == current_index)
	
	# Ensure the newly visible model matches the currently selected color
	apply_color_to_model()
	print("Currently viewing: ", current_model.name)

# Helper function to push the color to the shader
func apply_color_to_model():
	if current_model:
		var mat = current_model.get_active_material(0) as ShaderMaterial
		if mat:
			mat.set_shader_parameter("filament_color", colors[color_index])

func _on_printer_button_pressed(button_type: Variant) -> void:
	# Don't allow button presses if on cooldown OR if currently printing
	if not can_press or animation_player.is_playing():
		return
	
	can_press = false
	
	match button_type:
		"right":
			current_index = (current_index + 1) % models.size()
			update_model_selection()
			
		"left":
			current_index = (current_index - 1 + models.size()) % models.size()
			update_model_selection()
		
		# 3. New Color Selection Logic
		"up":
			color_index = (color_index + 1) % colors.size()
			apply_color_to_model()
			
		"down":
			color_index = (color_index - 1 + colors.size()) % colors.size()
			apply_color_to_model()
			
		"center": 
			start_print()

	await get_tree().create_timer(0.5).timeout
	can_press = true

func start_print():
	status_label.text = "Status: PRINTING..."
	# Ensure plane starts at the bottom before animation
	plane_node.position.y = 0.0 
	animation_player.play("print")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	status_label.text = "PRINT DONE!\nTake your item."
