extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_camera_limits()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $TextureProgress.value != $KinematicBody2D.current_health:
		$TextureProgress.value=$KinematicBody2D.current_health

func set_camera_limits():
	var map_limits = $TileMap.get_used_rect()
	var map_cellsize = $TileMap.cell_size
	$KinematicBody2D/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	$KinematicBody2D/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
	$KinematicBody2D/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	$KinematicBody2D/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y

func _on_spawn_timer_timeout():
	var enemy_instance = load("res://enemy.tscn").instance()

	randomize()
	var spawn_point = randi() % 6
	var spawn_array = $KinematicBody2D/spawn_container.get_children()
	enemy_instance.global_position = spawn_array[spawn_point].global_position
	$enemy_container.add_child(enemy_instance)
	
