extends XRController3D

var active_Collider = null
var current_Collider = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var start = global_position + (-global_basis.z * 0.05)
	var end = (-global_basis.z) + start
	$"LineRenderer".points[0] = start
	$"LineRenderer".points[1] = end
	
	$"RayCast3D".target_position = $"Raycast3D".to_local(end)
	
	if $"RayCast3D".is_colliding():
		current_Collider  = $"RayCast3D".get_collider()
		if active_Collider == null or active_Collider != current_Collider:
			active_Collider = current_Collider
			$"Popper".play()
			# play sound
	elif active_Collider != null:
		active_Collider = null
