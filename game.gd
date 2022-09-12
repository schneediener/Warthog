extends Node2D

var score = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_camera_limits()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Camera2D/TextureProgress.value != $KinematicBody2D.current_health:
		$Camera2D/TextureProgress.value= $KinematicBody2D.current_health
	if $Camera2D/TextEdit/Score.text != str(score):
		$Camera2D/TextEdit/Score.text = str(score)

func set_camera_limits():
	var map_limits = $TileMap.get_used_rect()
	var map_cellsize = $TileMap.cell_size
#	$Camera2D.limit_left = map_limits.position.x * map_cellsize.x
#	$Camera2D.limit_top = map_limits.position.y * map_cellsize.y
#	$Camera2D.limit_right = map_limits.end.x * map_cellsize.x
#	$Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y

func _on_spawn_timer_timeout():
	var enemy_instance = load("res://enemy.tscn").instance()

	randomize()
	var spawn_point = randi() % 8
	var spawn_array = $spawn_container.get_children()
	enemy_instance.global_position = spawn_array[spawn_point].global_position
	$enemy_container.add_child(enemy_instance)
	
