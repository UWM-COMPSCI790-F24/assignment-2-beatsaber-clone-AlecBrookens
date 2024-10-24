extends Node3D

# Variables for controlling the cube generation and movement
@export var z_position = -10.0
@export var move_speed = -1.75
@export var y_min = 0.1
@export var y_max = 1.8
@export var x_max = 1.75
@export var time_between_cubes = 1

var beat_times = [3]
var cubes = []
var current_beat = 0

var red_cube_scene = preload("res://RedCube.tscn")
var blue_cube_scene = preload("res://BlueCube.tscn")


func _ready():
	$Music.play()
	for i in range(160): 
		time_between_cubes = randf_range(.4, .9)
		beat_times.append(beat_times[-1] + time_between_cubes)
	generate_cubes()

func generate_cubes():
	while current_beat < beat_times.size():
		# Wait a short time (e.g., 0.1 seconds) and check if we need to create a cube
		await get_tree().create_timer(0.1).timeout

		var playback_position = $Music.get_playback_position()

		
		if playback_position >= beat_times[current_beat]:
			create_cube()
			current_beat += 1  # Move to the next beat

func create_cube():
	var bin = randi_range(0, 1)
	var cube = null
	if bin == 0:
		cube = red_cube_scene.instantiate()
	else:
		cube = blue_cube_scene.instantiate()

	var x_position = randf_range(-x_max, x_max)
	var y_position = randf_range(y_min, y_max)
	#cube.translation = Vector3(x_position, y_position, z_position)
	cube.global_position = Vector3(x_position, y_position, z_position)

	add_child(cube)
	cubes.append(cube)

func destroy_cube(cube):
	if cube:
		cube.queue_free()
		cubes.erase(cube)
	
func _process(delta):
	# Move cubes toward the user over time
	for cube in cubes:
		var new_z_position = cube.global_position.z - move_speed * delta
		cube.global_position.z = new_z_position
		if cube.global_position.z >= 1:
			destroy_cube(cube)
