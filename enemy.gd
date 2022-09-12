extends KinematicBody2D

var type = "enemy"
var subtype = "creep"
var velocity
var speed = 200
var current_health = 40
onready var player = get_node("/root/Node2D/KinematicBody2D")
onready var remaining_dist = global_position.distance_to(player.global_position)
var ready = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if $TextureProgress.value!=current_health:
		$TextureProgress.value=current_health
	remaining_dist = global_position.distance_to(player.global_position)
	if current_health <= 0:
		self.queue_free()
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
	match body.type:
		"bullet":
			body.queue_free()
			take_damage(body.damage)
		"warthog":
			if ready:
				body.take_damage(5, "normal")
				$HitDetection/Timer.start()
				ready = false

func take_damage(inc_damage):
	current_health = current_health - inc_damage



func _on_Timer_timeout():
	ready = true
