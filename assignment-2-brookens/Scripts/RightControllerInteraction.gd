extends XRController3D 

var active_Collider = null
var current_Collider = null
var lazer_Toggle = true 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var start = global_position + (-global_basis.z * 0.05)
	var end = (-global_basis.z) + start
	if is_button_pressed("ax_button"):
		if lazer_Toggle == true:
			lazer_Toggle = false
		if lazer_Toggle == false:
			lazer_Toggle = true
	
	if lazer_Toggle == true:
		$"LineRenderer".activate(true)
		$"LineRenderer".points[0] = start
		$"LineRenderer".points[1] = end
		$"RayCast3D".target_position = $"RayCast3D".to_local(end)
	
		if $"RayCast3D".is_colliding():
			current_Collider  = $"RayCast3D".get_collider()
			if active_Collider == null or active_Collider != current_Collider:
				active_Collider = current_Collider
				var cube = $"RayCast3D".get_collider().get_parent()
				if cube.cube_color == "Blue":
					cube.destroy_cube()
					$"Popper".play()
					
		elif active_Collider != null:
			active_Collider = null
	elif lazer_Toggle == false:
		$"LineRenderer".deactivate()
