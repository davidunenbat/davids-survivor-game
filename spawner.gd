extends Node2D

@onready var world_root = get_node("/root/World")
var enemy_scene := preload("res://enemy.tscn")
var spawn_locs = []
#collect all marker2d nodes
func _ready():
	for node in get_children():
		if node is Marker2D:
			spawn_locs.push_back(node)
#spawning logic
func _on_timer_timeout() -> void:
	
	var rand_loc = randi() % spawn_locs.size()
	var point = spawn_locs[rand_loc]
	
	var new_enemy = enemy_scene.instantiate()
	new_enemy.position = point.position
	world_root.add_child(new_enemy)
