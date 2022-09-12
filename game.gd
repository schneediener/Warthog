extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_spawn_timer_timeout():
	var enemy_instance = load("res://enemy.tscn").instance()

	randomize()
	var spawn_point = randi() % 6
	var spawn_array = $spawn_container.get_children()
	enemy_instance.global_position = spawn_array[spawn_point].global_position
	$enemy_container.add_child(enemy_instance)
	
