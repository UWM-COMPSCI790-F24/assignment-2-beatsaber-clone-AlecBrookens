extends Node3D

# Variables for controlling the cube generation and movement
@export var cube_size = 0.3
@export var z_position = 12.0
@export var move_speed = 2.0
@export var y_min = 0.4
@export var y_max = 2.0
@export var x_range = 2.0
@export var time_between_cubes = 0.8 # Change this based on beat detection

var beat_times = []
var cube_color_toggle = true
var cube_color = null
var cubes = []

func _ready():
	# Start generating cubes based on the beat of the audio file
	generate_cubes()
	
	# You can also play your audio here if it's attached in the scene:
	$"Music".play()

func generate_cubes():
	for beat_time in beat_times:
		await get_tree().create_timer(beat_time).timeout
		create_cube()

func create_cube():
	# Create a new cube
	var cube = MeshInstance3D.new()
	var cube_mesh = BoxMesh.new()
	cube_mesh.size = Vector3(cube_size, cube_size, cube_size)
	cube.mesh = cube_mesh
	
	# Set random position within the given range
	var x_position = randf_range(-x_range, x_range)
	var y_position = randf_range(y_min, y_max)
	cube.translation = Vector3(x_position, y_position, z_position)
	
	# Set alternating colors (red/blue)
	var material = StandardMaterial3D.new()
	if cube_color_toggle:
		material.albedo_color = Color(1, 0, 0) # Red
		cube_color = "Red"
	else:
		material.albedo_color = Color(0, 0, 1) # Blue
		cube_color = "Blue"
	cube_color_toggle = !cube_color_toggle
	cube.mesh.material_override = material
	
	# Add the cube to the scene
	add_child(cube)
	cubes.append(cube)
	
func destroy_cube():
	cubes.queue_free()
	cubes.erase(cubes.head)
	
func _process(delta):
	# Move cubes toward the user over time
	for cube in cubes:
		var new_z_position = cube.translation.z - move_speed * delta
		cube.translation.z = new_z_position
		# Remove the cube when it gets close to the user
		if cube.translation.z < -1:
			destroy_cube()
