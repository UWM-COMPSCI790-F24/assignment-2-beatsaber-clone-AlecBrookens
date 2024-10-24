extends XRController3D 

var active_Collider = null
var current_Collider = null
var lazer_Toggle = false 

func _ready() -> void:
	pass
func _process(delta: float) -> void:
	var start = global_position + (-global_basis.z * 0.05)
	var end = (-global_basis.z) + start
	
	if lazer_Toggle == true:
		$"LineRenderer".visible = true
		$"LineRenderer".points[0] = start
		$"LineRenderer".points[1] = end
		$"RayCast3D".target_position = $"RayCast3D".to_local(end)
	
		if $"RayCast3D".is_colliding():
			$"Popper".play()
			var cube = $"RayCast3D".get_collider().get_parent().get_parent()
			cube.global_position.y = -100
			current_Collider  = $"RayCast3D".get_collider()
			if active_Collider == null or active_Collider != current_Collider:
				active_Collider = current_Collider
				#var cube = $"RayCast3D".get_collider().get_grandparent()
				cube.destroy_cube(cube)
				$"Popper".play()
					
		elif active_Collider != null:
			active_Collider = null
	elif lazer_Toggle == false:
		$"LineRenderer".visible = false
func _on_button_pressed(name: String) -> void:
	if name == "ax_button":
		lazer_Toggle = !lazer_Toggle
