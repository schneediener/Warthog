extends KinematicBody2D

var type = "enemy"
var subtype = "creep"
var velocity
var speed = 100
onready var player = get_node("/root/Node2D/KinematicBody2D")
onready var remaining_dist = global_position.distance_to(player.global_position)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player:
		velocity = position.direction_to(player.position) * speed
	velocity = move_and_slide(velocity)

func get_distance():
	return remaining_dist

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HitDetection_body_entered(body):
	if body.type=="bullet":
		body.queue_free()
		self.queue_free()
