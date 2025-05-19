extends Node3D
class_name RailWaySpawner

const RAILWAY = preload("res://Scenes/Railway/Railway.tscn")
@export var rail_parent: Node3D
# when spawing in the railway, we have to keep in mind the offset,
# also making sure that when the railway spawns in, there is an overlap on the first and last plank
var rail_length: float = 3.123
var rail_parts: Array[Node3D] = []
var movement_speed: float = 0.1
var crossed_distance: float = 0
# flag for "starting the train"
var should_move_railing: float = true

func _ready():
	# when entering the scene, spawn in 10 in the front of the player/cart
	# 10 in the back
	# the spawner should be in the world origin!
	for i in range(10, -1, -1):
		var rail_front = RAILWAY.instantiate()
		rail_front.position.z += i * rail_length
		rail_parent.add_child(rail_front)
	for i in range(0, 10):
		var rail_back = RAILWAY.instantiate()
		rail_back.position.z -= (i+1) * rail_length
		rail_parent.add_child(rail_back)
	
	for child in rail_parent.get_children():
		rail_parts.append(child)
		print(child.position)


func _process(_delta):
	for rail in rail_parts:
		rail.position.z -= movement_speed
	crossed_distance += movement_speed
	if crossed_distance >= rail_length:
		var rail_front = RAILWAY.instantiate()
		rail_front.position.z += 10 * rail_length
		rail_parent.add_child(rail_front)
		rail_parts.insert(0, rail_front)
		var rail_back = rail_parts.get(rail_parts.size()-1)
		rail_parts.resize(rail_parts.size()-1)
		rail_parent.remove_child(rail_back)
		crossed_distance = 0
	await get_tree().create_timer(0.5).timeout
